const Grievance = require('../models/Grievance');
const User = require('../models/User');
const { generateAnonymousId, sendEmail, getGrievanceNotificationTemplate } = require('../utils/helpers');

// @desc    Create new grievance
// @route   POST /api/grievances
// @access  Private
exports.createGrievance = async (req, res) => {
    try {
        const {
            title,
            description,
            category,
            isAnonymous,
            isEmergency,
            priority
        } = req.body;

        // Validation
        if (!title || !description || !category) {
            return res.status(400).json({
                success: false,
                message: 'Please provide title, description, and category'
            });
        }

        // Prepare grievance data
        const grievanceData = {
            title,
            description,
            category,
            isAnonymous: isAnonymous || false,
            isEmergency: isEmergency || false,
            priority: priority || (isEmergency ? 'urgent' : 'medium')
        };

        // Set user ID or anonymous ID
        if (isAnonymous) {
            grievanceData.anonymousId = generateAnonymousId();
        } else {
            grievanceData.userId = req.user.id;
        }

        // Handle file attachments if any
        if (req.files && req.files.length > 0) {
            grievanceData.attachments = req.files.map(file => ({
                filename: file.filename,
                originalName: file.originalname,
                mimetype: file.mimetype,
                size: file.size,
                path: file.path
            }));
        }

        // Create grievance
        const grievance = await Grievance.create(grievanceData);

        // Send email notification (if not anonymous)
        if (!isAnonymous) {
            try {
                await sendEmail({
                    email: req.user.email,
                    subject: 'Grievance Submitted Successfully - RiseVoice',
                    html: getGrievanceNotificationTemplate(grievance, 'submitted')
                });
            } catch (emailError) {
                console.error('Email notification error:', emailError);
                // Don't fail the request if email fails
            }
        }

        res.status(201).json({
            success: true,
            message: 'Grievance submitted successfully',
            grievance: await Grievance.findById(grievance._id)
                .populate('userId', 'rollNumber email name')
                .populate('assignedTo', 'name role')
        });

    } catch (error) {
        console.error('Create grievance error:', error);
        res.status(500).json({
            success: false,
            message: 'Server error while creating grievance'
        });
    }
};

// @desc    Get all grievances for current user
// @route   GET /api/grievances/my
// @access  Private
exports.getMyGrievances = async (req, res) => {
    try {
        const { status, category, priority, page = 1, limit = 20 } = req.query;

        // Build query
        const query = { userId: req.user.id };

        if (status) query.status = status;
        if (category) query.category = category;
        if (priority) query.priority = priority;

        // Execute query with pagination
        const grievances = await Grievance.find(query)
            .populate('assignedTo', 'name role')
            .sort({ createdAt: -1 })
            .limit(limit * 1)
            .skip((page - 1) * limit);

        const count = await Grievance.countDocuments(query);

        res.status(200).json({
            success: true,
            count: grievances.length,
            total: count,
            totalPages: Math.ceil(count / limit),
            currentPage: page,
            grievances
        });

    } catch (error) {
        console.error('Get my grievances error:', error);
        res.status(500).json({
            success: false,
            message: 'Server error while fetching grievances'
        });
    }
};

// @desc    Get single grievance
// @route   GET /api/grievances/:id
// @access  Private
exports.getGrievance = async (req, res) => {
    try {
        const grievance = await Grievance.findById(req.params.id)
            .populate('userId', 'rollNumber email name')
            .populate('assignedTo', 'name role')
            .populate('updates.updatedBy', 'name role');

        if (!grievance) {
            return res.status(404).json({
                success: false,
                message: 'Grievance not found'
            });
        }

        // Check authorization
        // User can view their own grievances or if they're committee/admin
        const isOwner = grievance.userId && grievance.userId._id.toString() === req.user.id;
        const isAuthorized = ['committee', 'admin'].includes(req.user.role);

        if (!isOwner && !isAuthorized) {
            return res.status(403).json({
                success: false,
                message: 'Not authorized to view this grievance'
            });
        }

        res.status(200).json({
            success: true,
            grievance
        });

    } catch (error) {
        console.error('Get grievance error:', error);
        res.status(500).json({
            success: false,
            message: 'Server error while fetching grievance'
        });
    }
};

// @desc    Get grievance by anonymous ID
// @route   GET /api/grievances/anonymous/:anonymousId
// @access  Public
exports.getGrievanceByAnonymousId = async (req, res) => {
    try {
        const grievance = await Grievance.findOne({ anonymousId: req.params.anonymousId })
            .populate('assignedTo', 'name role')
            .populate('updates.updatedBy', 'name role');

        if (!grievance) {
            return res.status(404).json({
                success: false,
                message: 'Grievance not found'
            });
        }

        res.status(200).json({
            success: true,
            grievance
        });

    } catch (error) {
        console.error('Get anonymous grievance error:', error);
        res.status(500).json({
            success: false,
            message: 'Server error while fetching grievance'
        });
    }
};

// @desc    Get all grievances (Admin/Committee)
// @route   GET /api/grievances
// @access  Private (Committee/Admin)
exports.getAllGrievances = async (req, res) => {
    try {
        const {
            status,
            category,
            priority,
            isEmergency,
            assignedTo,
            page = 1,
            limit = 20,
            sort = '-createdAt'
        } = req.query;

        // Build query
        const query = {};

        if (status) query.status = status;
        if (category) query.category = category;
        if (priority) query.priority = priority;
        if (isEmergency) query.isEmergency = isEmergency === 'true';
        if (assignedTo) query.assignedTo = assignedTo;

        // If committee member, show only assigned grievances
        if (req.user.role === 'committee') {
            query.assignedTo = req.user.id;
        }

        // Execute query
        const grievances = await Grievance.find(query)
            .populate('userId', 'rollNumber email name')
            .populate('assignedTo', 'name role')
            .sort(sort)
            .limit(limit * 1)
            .skip((page - 1) * limit);

        const count = await Grievance.countDocuments(query);

        res.status(200).json({
            success: true,
            count: grievances.length,
            total: count,
            totalPages: Math.ceil(count / limit),
            currentPage: page,
            grievances
        });

    } catch (error) {
        console.error('Get all grievances error:', error);
        res.status(500).json({
            success: false,
            message: 'Server error while fetching grievances'
        });
    }
};

// @desc    Update grievance status
// @route   PUT /api/grievances/:id/status
// @access  Private (Committee/Admin)
exports.updateGrievanceStatus = async (req, res) => {
    try {
        const { status, message } = req.body;

        if (!status) {
            return res.status(400).json({
                success: false,
                message: 'Please provide status'
            });
        }

        const grievance = await Grievance.findById(req.params.id);

        if (!grievance) {
            return res.status(404).json({
                success: false,
                message: 'Grievance not found'
            });
        }

        // Update status
        grievance.status = status;

        // Add update message
        if (message) {
            grievance.updates.push({
                message,
                updatedBy: req.user.id,
                updatedByRole: req.user.role
            });
        }

        await grievance.save();

        // Send email notification (if not anonymous)
        if (grievance.userId) {
            try {
                const user = await User.findById(grievance.userId);
                if (user) {
                    await sendEmail({
                        email: user.email,
                        subject: 'Grievance Status Updated - RiseVoice',
                        html: getGrievanceNotificationTemplate(grievance, 'updated')
                    });
                }
            } catch (emailError) {
                console.error('Email notification error:', emailError);
            }
        }

        res.status(200).json({
            success: true,
            message: 'Grievance status updated successfully',
            grievance: await Grievance.findById(grievance._id)
                .populate('userId', 'rollNumber email name')
                .populate('assignedTo', 'name role')
                .populate('updates.updatedBy', 'name role')
        });

    } catch (error) {
        console.error('Update grievance status error:', error);
        res.status(500).json({
            success: false,
            message: 'Server error while updating grievance'
        });
    }
};

// @desc    Assign grievance to committee member
// @route   PUT /api/grievances/:id/assign
// @access  Private (Admin)
exports.assignGrievance = async (req, res) => {
    try {
        const { assignedTo } = req.body;

        if (!assignedTo) {
            return res.status(400).json({
                success: false,
                message: 'Please provide user ID to assign'
            });
        }

        const grievance = await Grievance.findById(req.params.id);

        if (!grievance) {
            return res.status(404).json({
                success: false,
                message: 'Grievance not found'
            });
        }

        // Verify assigned user exists and is committee member
        const assignedUser = await User.findById(assignedTo);
        if (!assignedUser || assignedUser.role !== 'committee') {
            return res.status(400).json({
                success: false,
                message: 'Invalid committee member'
            });
        }

        grievance.assignedTo = assignedTo;
        grievance.status = 'under_review';

        grievance.updates.push({
            message: `Grievance assigned to ${assignedUser.name || assignedUser.email}`,
            updatedBy: req.user.id,
            updatedByRole: req.user.role
        });

        await grievance.save();

        res.status(200).json({
            success: true,
            message: 'Grievance assigned successfully',
            grievance: await Grievance.findById(grievance._id)
                .populate('userId', 'rollNumber email name')
                .populate('assignedTo', 'name role')
        });

    } catch (error) {
        console.error('Assign grievance error:', error);
        res.status(500).json({
            success: false,
            message: 'Server error while assigning grievance'
        });
    }
};

// @desc    Add update/comment to grievance
// @route   POST /api/grievances/:id/updates
// @access  Private (Committee/Admin)
exports.addGrievanceUpdate = async (req, res) => {
    try {
        const { message } = req.body;

        if (!message) {
            return res.status(400).json({
                success: false,
                message: 'Please provide update message'
            });
        }

        const grievance = await Grievance.findById(req.params.id);

        if (!grievance) {
            return res.status(404).json({
                success: false,
                message: 'Grievance not found'
            });
        }

        grievance.updates.push({
            message,
            updatedBy: req.user.id,
            updatedByRole: req.user.role
        });

        await grievance.save();

        res.status(200).json({
            success: true,
            message: 'Update added successfully',
            grievance: await Grievance.findById(grievance._id)
                .populate('updates.updatedBy', 'name role')
        });

    } catch (error) {
        console.error('Add grievance update error:', error);
        res.status(500).json({
            success: false,
            message: 'Server error while adding update'
        });
    }
};

// @desc    Get grievance statistics
// @route   GET /api/grievances/stats
// @access  Private
exports.getGrievanceStats = async (req, res) => {
    try {
        const userId = req.user.id;

        const stats = await Grievance.aggregate([
            { $match: { userId: mongoose.Types.ObjectId(userId) } },
            {
                $group: {
                    _id: '$status',
                    count: { $sum: 1 }
                }
            }
        ]);

        const total = await Grievance.countDocuments({ userId });

        const formattedStats = {
            total,
            pending: 0,
            under_review: 0,
            in_progress: 0,
            resolved: 0,
            rejected: 0
        };

        stats.forEach(stat => {
            formattedStats[stat._id] = stat.count;
        });

        res.status(200).json({
            success: true,
            stats: formattedStats
        });

    } catch (error) {
        console.error('Get grievance stats error:', error);
        res.status(500).json({
            success: false,
            message: 'Server error while fetching statistics'
        });
    }
};

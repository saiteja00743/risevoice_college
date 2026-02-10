const jwt = require('jsonwebtoken');
const User = require('../models/User');

// @desc    Simple Login (Roll Number only)
// @route   POST /api/auth/login
// @access  Public
exports.login = async (req, res) => {
    try {
        const { rollNumber, email } = req.body;

        if (!rollNumber || !email) {
            return res.status(400).json({
                success: false,
                message: 'Please provide roll number and email'
            });
        }

        // Find or create user
        let user = await User.findOne({
            rollNumber: rollNumber.toUpperCase(),
            email: email.toLowerCase()
        });

        if (!user) {
            // Create new user
            user = await User.create({
                rollNumber: rollNumber.toUpperCase(),
                email: email.toLowerCase(),
                isEmailVerified: true,
                role: 'student'
            });
        } else {
            // Update last login
            user.lastLogin = new Date();
            await user.save();
        }

        // Generate JWT token
        const token = jwt.sign(
            { id: user._id },
            process.env.JWT_SECRET,
            { expiresIn: process.env.JWT_EXPIRE || '30d' }
        );

        res.status(200).json({
            success: true,
            message: 'Login successful',
            token,
            user: {
                id: user._id,
                rollNumber: user.rollNumber,
                email: user.email,
                name: user.name,
                role: user.role,
                department: user.department,
                year: user.year,
                isEmailVerified: user.isEmailVerified,
                createdAt: user.createdAt
            }
        });

    } catch (error) {
        console.error('Login error:', error);

        // Help debug missing environment variables
        if (!process.env.JWT_SECRET) {
            return res.status(500).json({
                success: false,
                message: 'INTERNAL ERROR: JWT_SECRET is missing on server.'
            });
        }

        res.status(500).json({
            success: false,
            message: `Server error: ${error.message}`
        });
    }
};

// @desc    Get current user
// @route   GET /api/auth/me
// @access  Private
exports.getMe = async (req, res) => {
    try {
        const user = await User.findById(req.user.id);

        res.status(200).json({
            success: true,
            user: {
                id: user._id,
                rollNumber: user.rollNumber,
                email: user.email,
                name: user.name,
                role: user.role,
                department: user.department,
                year: user.year,
                isEmailVerified: user.isEmailVerified,
                createdAt: user.createdAt
            }
        });
    } catch (error) {
        console.error('Get me error:', error);
        res.status(500).json({
            success: false,
            message: 'Server error'
        });
    }
};

// @desc    Update user profile
// @route   PUT /api/auth/profile
// @access  Private
exports.updateProfile = async (req, res) => {
    try {
        const { name, department, year } = req.body;

        const user = await User.findById(req.user.id);

        if (name) user.name = name;
        if (department) user.department = department;
        if (year) user.year = year;

        await user.save();

        res.status(200).json({
            success: true,
            message: 'Profile updated successfully',
            user: {
                id: user._id,
                rollNumber: user.rollNumber,
                email: user.email,
                name: user.name,
                role: user.role,
                department: user.department,
                year: user.year
            }
        });
    } catch (error) {
        console.error('Update profile error:', error);
        res.status(500).json({
            success: false,
            message: 'Server error while updating profile'
        });
    }
};

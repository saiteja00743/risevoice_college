const mongoose = require('mongoose');

const grievanceSchema = new mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: function () {
            return !this.isAnonymous;
        }
    },
    anonymousId: {
        type: String,
        required: function () {
            return this.isAnonymous;
        },
        index: true
    },
    title: {
        type: String,
        required: [true, 'Title is required'],
        trim: true,
        minlength: [5, 'Title must be at least 5 characters'],
        maxlength: [200, 'Title cannot exceed 200 characters']
    },
    description: {
        type: String,
        required: [true, 'Description is required'],
        trim: true,
        minlength: [20, 'Description must be at least 20 characters'],
        maxlength: [2000, 'Description cannot exceed 2000 characters']
    },
    category: {
        type: String,
        required: [true, 'Category is required'],
        enum: [
            'Academic Issues',
            'Infrastructure',
            'Faculty Behavior',
            'Examination',
            'Library',
            'Hostel',
            'Canteen',
            'Transportation',
            'Ragging/Harassment',
            'Discrimination',
            'Safety & Security',
            'Administrative',
            'Other'
        ]
    },
    status: {
        type: String,
        enum: ['pending', 'under_review', 'in_progress', 'resolved', 'rejected'],
        default: 'pending',
        index: true
    },
    priority: {
        type: String,
        enum: ['low', 'medium', 'high', 'urgent'],
        default: 'medium',
        index: true
    },
    isAnonymous: {
        type: Boolean,
        default: false
    },
    isEmergency: {
        type: Boolean,
        default: false
    },
    attachments: [{
        filename: String,
        originalName: String,
        mimetype: String,
        size: Number,
        path: String,
        uploadedAt: {
            type: Date,
            default: Date.now
        }
    }],
    assignedTo: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User'
    },
    updates: [{
        message: {
            type: String,
            required: true
        },
        updatedBy: {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'User',
            required: true
        },
        updatedByRole: {
            type: String,
            enum: ['student', 'committee', 'admin']
        },
        createdAt: {
            type: Date,
            default: Date.now
        }
    }],
    resolvedAt: {
        type: Date
    },
    createdAt: {
        type: Date,
        default: Date.now,
        index: true
    },
    updatedAt: {
        type: Date,
        default: Date.now
    }
});

// Update timestamp on save
grievanceSchema.pre('save', function (next) {
    this.updatedAt = Date.now();

    // Set resolvedAt when status changes to resolved
    if (this.isModified('status') && this.status === 'resolved' && !this.resolvedAt) {
        this.resolvedAt = Date.now();
    }

    next();
});

// Compound indexes for efficient queries
grievanceSchema.index({ userId: 1, status: 1, createdAt: -1 });
grievanceSchema.index({ anonymousId: 1, createdAt: -1 });
grievanceSchema.index({ category: 1, status: 1 });
grievanceSchema.index({ priority: 1, status: 1 });

module.exports = mongoose.model('Grievance', grievanceSchema);

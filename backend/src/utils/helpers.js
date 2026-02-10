const crypto = require('crypto');
const nodemailer = require('nodemailer');

// Generate random OTP
exports.generateOTP = (length = 6) => {
    const digits = '0123456789';
    let otp = '';

    for (let i = 0; i < length; i++) {
        otp += digits[Math.floor(Math.random() * 10)];
    }

    return otp;
};

// Generate anonymous ID
exports.generateAnonymousId = () => {
    return crypto.randomBytes(8).toString('hex');
};

// Send email
exports.sendEmail = async (options) => {
    // Create transporter
    const transporter = nodemailer.createTransporter({
        service: process.env.EMAIL_SERVICE || 'gmail',
        auth: {
            user: process.env.EMAIL_USER,
            pass: process.env.EMAIL_PASSWORD
        }
    });

    // Email options
    const mailOptions = {
        from: `${process.env.COLLEGE_NAME} <${process.env.EMAIL_USER}>`,
        to: options.email,
        subject: options.subject,
        html: options.html
    };

    // Send email
    await transporter.sendMail(mailOptions);
};

// OTP Email Template
exports.getOTPEmailTemplate = (otp, rollNumber) => {
    return `
    <!DOCTYPE html>
    <html>
    <head>
      <style>
        body { font-family: 'Inter', Arial, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: linear-gradient(135deg, #2563EB 0%, #0D9488 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }
        .content { background: #f8f9fa; padding: 30px; border-radius: 0 0 10px 10px; }
        .otp-box { background: white; border: 2px solid #2563EB; border-radius: 10px; padding: 20px; text-align: center; margin: 20px 0; }
        .otp { font-size: 32px; font-weight: bold; color: #2563EB; letter-spacing: 5px; }
        .footer { text-align: center; margin-top: 20px; color: #666; font-size: 12px; }
      </style>
    </head>
    <body>
      <div class="container">
        <div class="header">
          <h1>🎯 RiseVoice</h1>
          <p>Your voice is safe here</p>
        </div>
        <div class="content">
          <h2>Login Verification Code</h2>
          <p>Hello,</p>
          <p>You requested to login to RiseVoice with roll number <strong>${rollNumber}</strong>.</p>
          <p>Your One-Time Password (OTP) is:</p>
          <div class="otp-box">
            <div class="otp">${otp}</div>
          </div>
          <p><strong>This OTP will expire in ${process.env.OTP_EXPIRE_MINUTES || 5} minutes.</strong></p>
          <p>If you didn't request this code, please ignore this email.</p>
          <hr style="margin: 30px 0; border: none; border-top: 1px solid #ddd;">
          <p style="color: #666; font-size: 14px;">
            <strong>Security Tips:</strong><br>
            • Never share your OTP with anyone<br>
            • RiseVoice will never ask for your OTP via phone or SMS<br>
            • Always verify the sender's email address
          </p>
        </div>
        <div class="footer">
          <p>${process.env.COLLEGE_NAME}<br>
          Hanamkonda, Telangana</p>
          <p>This is an automated email. Please do not reply.</p>
        </div>
      </div>
    </body>
    </html>
  `;
};

// Grievance notification email template
exports.getGrievanceNotificationTemplate = (grievance, type) => {
    const statusColors = {
        pending: '#F59E0B',
        under_review: '#3B82F6',
        in_progress: '#0D9488',
        resolved: '#10B981',
        rejected: '#EF4444'
    };

    const color = statusColors[grievance.status] || '#666';

    return `
    <!DOCTYPE html>
    <html>
    <head>
      <style>
        body { font-family: 'Inter', Arial, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: linear-gradient(135deg, #2563EB 0%, #0D9488 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }
        .content { background: #f8f9fa; padding: 30px; border-radius: 0 0 10px 10px; }
        .status-badge { display: inline-block; padding: 8px 16px; border-radius: 20px; background: ${color}; color: white; font-weight: bold; }
        .info-box { background: white; padding: 20px; border-radius: 10px; margin: 20px 0; border-left: 4px solid ${color}; }
      </style>
    </head>
    <body>
      <div class="container">
        <div class="header">
          <h1>🎯 RiseVoice</h1>
          <p>Grievance ${type === 'submitted' ? 'Submitted' : 'Updated'}</p>
        </div>
        <div class="content">
          <h2>${type === 'submitted' ? 'Grievance Submitted Successfully' : 'Grievance Status Updated'}</h2>
          <div class="info-box">
            <p><strong>Grievance ID:</strong> ${grievance._id}</p>
            <p><strong>Category:</strong> ${grievance.category}</p>
            <p><strong>Status:</strong> <span class="status-badge">${grievance.status.replace('_', ' ').toUpperCase()}</span></p>
            <p><strong>Priority:</strong> ${grievance.priority.toUpperCase()}</p>
            ${grievance.isEmergency ? '<p><strong>⚠️ EMERGENCY GRIEVANCE</strong></p>' : ''}
          </div>
          <p>${type === 'submitted' ?
            'Your grievance has been submitted successfully and is being reviewed by the committee.' :
            'There has been an update to your grievance. Please check the app for details.'
        }</p>
          <p>Login to RiseVoice app to track your grievance status.</p>
        </div>
        <div class="footer">
          <p>${process.env.COLLEGE_NAME}</p>
        </div>
      </div>
    </body>
    </html>
  `;
};

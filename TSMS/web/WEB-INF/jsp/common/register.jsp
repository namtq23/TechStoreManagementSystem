<%-- 
    Document   : register
    Created on : May 25, 2025, 8:14:03 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Đăng Ký</title>
        <link rel="stylesheet" type="text/css" href="css/register.css">
    </head>
    <body>
        <div class="register-container">
            <div class="register-box">
                <h2 class="logo-text">TSMS</h2>
                <p class="subtitle">Create Your Shop Account</p>
                <form action="register" method="post">
                    <div class="form-row">
                        <input type="text" name="fullname" placeholder="Full Name" required>
                    </div>
                    
                    <div class="form-row">
                        <input type="text" name="shopname" placeholder="Shop Name" required>
                    </div>
                    
                    <div class="form-row">
                        <input type="email" name="email" placeholder="Email Address" required>
                    </div>
                    
                    <div class="form-row">
                        <input type="password" name="password" placeholder="Password" required>
                    </div>
                    
                    <div class="form-row">
                        <input type="password" name="confirmpassword" placeholder="Confirm Password" required>
                    </div>
                    
                    <div class="checkbox-container">
                        <label class="checkbox-label">
                            <input type="checkbox" name="agree" required>
                            <span class="checkmark"></span>
                            I agree to the <a href="#" class="terms-link">Terms of Service</a> and <a href="#" class="terms-link">Privacy Policy</a>
                        </label>
                    </div>
                    
                    <div class="buttons">
                        <button type="submit" class="btn-register">Create Account</button>
                        <div class="login-link">
                            Already have an account? <a href="login">Sign In</a>
                        </div>
                    </div>
                </form>
            </div>
        </div>
        
        <script>
            // Password confirmation validation
            document.querySelector('form').addEventListener('submit', function(e) {
                const password = document.querySelector('input[name="password"]').value;
                const confirmPassword = document.querySelector('input[name="confirmpassword"]').value;
                
                if (password !== confirmPassword) {
                    e.preventDefault();
                    alert('Passwords do not match!');
                    return false;
                }
            });
            
            // Real-time password match indicator
            const passwordInput = document.querySelector('input[name="password"]');
            const confirmPasswordInput = document.querySelector('input[name="confirmpassword"]');
            
            function checkPasswordMatch() {
                if (confirmPasswordInput.value === '') {
                    confirmPasswordInput.style.borderColor = '#e1e8ed';
                    return;
                }
                
                if (passwordInput.value === confirmPasswordInput.value) {
                    confirmPasswordInput.style.borderColor = '#28a745';
                } else {
                    confirmPasswordInput.style.borderColor = '#dc3545';
                }
            }
            
            confirmPasswordInput.addEventListener('input', checkPasswordMatch);
            passwordInput.addEventListener('input', checkPasswordMatch);
        </script>
    </body>
</html>

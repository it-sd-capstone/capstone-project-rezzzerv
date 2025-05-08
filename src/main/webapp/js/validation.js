function pulseRed(input) {
    input.classList.add('invalidPulse');
    input.addEventListener('animationend', () => {
        input.classList.remove('invalidPulse');
    }, { once: true });
}

function restrictToDigits(e) {
    if (!/^\d$/.test(e.key)) {
        e.preventDefault();
        pulseRed(e.target);
    }
}

function restrictMoneyInput(e) {
    const tgt    = e.target;
    const key    = e.key;
    const val    = tgt.value;
    const hasDot = val.includes('.');

    if (key === '.') {

        if (hasDot) {
            e.preventDefault();
            pulseRed(tgt);
        }
        return;
    }

    if (/^\d$/.test(key)) {
        if (hasDot) {
            const [intPart, decPart] = val.split('.');

            if (decPart.length >= 2) {
                e.preventDefault();
                pulseRed(tgt);
            }
        }
        return;
    }
    e.preventDefault();
    pulseRed(tgt);
}

function initDigitsOnly(field) {
    if (!field) return;
    field.addEventListener('keypress', restrictToDigits);
}

function initMoneyField(field) {
    if (!field) return;
    field.addEventListener('keypress', restrictMoneyInput);
    field.addEventListener('input', () => {
        let val = field.value.replace(/[^0-9.]/g, '');
        if (val.includes('.')) {
            const [intPart, decPart] = val.split('.');
            val = intPart + '.' + decPart.slice(0, 2);
        }
        if (val !== field.value) {
            field.value = val;
            pulseRed(field);
        }
    });
}

document.addEventListener('DOMContentLoaded', () => {

    const roomNumberField = document.getElementById('roomNumber');
    const roomPriceField  = document.getElementById('roomPrice');

    const editRoomNumber  = document.getElementById('editRoomNumber');
    const editRoomPrice   = document.getElementById('editRoomPrice');

    initDigitsOnly(roomNumberField);
    initMoneyField(roomPriceField);
    initDigitsOnly(editRoomNumber);
    initMoneyField(editRoomPrice);
});


// Utility function for validation forms
function toggleValidClass(input, isValid) {
    const wrapper = input.parentElement;
    if (isValid) {
        wrapper.classList.add('valid');
    } else {
        wrapper.classList.remove('valid');
    }
}


// Register Form Validation
const registerForm = document.getElementById('register-form');
const registerBtn = document.getElementById('register-btn');

if (registerForm && registerBtn) {
    const nameInput = document.getElementById('name');
    const lastNameInput = document.getElementById('lastName');
    const emailInput = document.getElementById('email');
    const phoneInput = document.getElementById('phone');
    const passwordInput = document.getElementById('password');
    const confirmPasswordInput = document.getElementById('confirm-password');
    const errorContainer = document.getElementById('password-errors');
    const strengthBar = document.getElementById('strength-bar');
    const formError = document.getElementById('form-error');
    let emailTaken = false;
    let emailCheckTimeout;

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    // Live Email Check
    emailInput.addEventListener('input', function() {
        clearTimeout(emailCheckTimeout); // reset the 300ms timer if still typing

        const email = emailInput.value.trim();

        emailCheckTimeout = setTimeout(() => {
            if (email.length > 5) {
                fetch(`check-email?email=${encodeURIComponent(email)}`)
                    .then(response => response.json())
                    .then(data => {
                        if (data.exists) {
                            emailTaken = true;
                            formError.style.display = "block";
                            formError.textContent = "This email is already registered. Please login or use a different email.";
                        } else {
                            emailTaken = false;
                            formError.style.display = "none";
                        }

                        // Re-validate after fetch response
                        validateForm();
                        
                    })
                    .catch(error => {
                        console.error('Error checking email:', error);
                    });
            } else {
                emailTaken = false;
                formError.style.display = "none";
                validateForm();
            }
        }, 300);
    });

    function validateForm() {
        const isNameValid = nameInput.value.trim().length >= 2;
        const isLastNameValid = lastNameInput.value.trim().length >= 2;
        const isPhoneValid = phoneInput.value.trim().length >= 10;
        const isEmailValid = emailRegex.test(emailInput.value.trim());
        const isPasswordValid = validatePassword(passwordInput.value, false);
        const isPasswordMatch = passwordInput.value === confirmPasswordInput.value && passwordInput.value.length > 0;

        toggleValidClass(nameInput, isNameValid);
        toggleValidClass(lastNameInput, isLastNameValid);
        toggleValidClass(phoneInput, isPhoneValid);
        toggleValidClass(emailInput, isEmailValid && !emailTaken);
        toggleValidClass(passwordInput, isPasswordValid);
        toggleValidClass(confirmPasswordInput, isPasswordMatch);

        const isFormValid = isNameValid && isLastNameValid && isPhoneValid && isEmailValid && isPasswordValid && isPasswordMatch && !emailTaken;
        registerBtn.disabled = !isFormValid;
        registerBtn.classList.toggle('enabled', isFormValid);
    }

    function validatePassword(password, showErrors = true) {
        const errors = [];

        const ruleLength = document.getElementById('rule-length');
        const ruleLowercase = document.getElementById('rule-lowercase');
        const ruleUppercase = document.getElementById('rule-uppercase');
        const ruleNumber = document.getElementById('rule-number');
        const ruleSpecial = document.getElementById('rule-special');

        // Check individual rules
        const hasLength = password.length >= 8;
        const hasLowercase = /[a-z]/.test(password);
        const hasUppercase = /[A-Z]/.test(password);
        const hasNumber = /[0-9]/.test(password);
        const hasSpecial = /[!@#$%^&*(),.?\":{}|<>]/.test(password);

        // Update rule indicators
        toggleRule(ruleLength, hasLength);
        toggleRule(ruleLowercase, hasLowercase);
        toggleRule(ruleUppercase, hasUppercase);
        toggleRule(ruleNumber, hasNumber);
        toggleRule(ruleSpecial, hasSpecial);

        if (!hasLength) {
            errors.push("Password must be at least 8 characters long.");
        }
        if (!hasLowercase) {
            errors.push("Must contain at least one lowercase letter.");
        }
        if (!hasUppercase) {
            errors.push("Must contain at least one uppercase letter.");
        }
        if (!hasNumber) {
            errors.push("Must contain at least one number (0-9).");
        }
        if (!hasSpecial) {
            errors.push("Must contain at least one special character.");
        }

        if (showErrors) {
            displayErrors(errors);
        }

        updateStrengthBar(password);

        return errors.length === 0;
    }

    function toggleRule(element, isValid) {
        if (isValid) {
            element.classList.add('valid');
        } else {
            element.classList.remove('valid');
        }
    }

    function displayErrors(errors) {
        if (errors.length > 0) {
            errorContainer.innerHTML = "<ul><li>" + errors.join("</li><li>") + "</li></ul>";
        } else {
            errorContainer.innerHTML = "";
        }
    }

    function updateStrengthBar(password) {
        let strength = 0;

        if (password.length >= 8) strength++;
        if (/[a-z]/.test(password)) strength++;
        if (/[A-Z]/.test(password)) strength++;
        if (/[0-9]/.test(password)) strength++;
        if (/[!@#$%^&*(),.?\":{}|<>]/.test(password)) strength++;

        strengthBar.style.backgroundColor = "#7a51c0";

        if (strength === 0) {
            strengthBar.style.width = "0%";
        } else if (strength <= 2) {
            strengthBar.style.width = "10%";
        } else if (strength <= 3) {
            strengthBar.style.width = "40%";
        } else if (strength <= 4) {
            strengthBar.style.width = "70%";
        } else if (strength === 5) {
            strengthBar.style.width = "100%";
        }
    }

    nameInput.addEventListener('input', validateForm);
    lastNameInput.addEventListener('input', validateForm);
    phoneInput.addEventListener('input', validateForm);
    emailInput.addEventListener('input', validateForm);
    passwordInput.addEventListener('input', validateForm);
    confirmPasswordInput.addEventListener('input', validateForm);
}


// Login Form Validation
const loginForm = document.getElementById('login-form');
const loginBtn = document.getElementById('login-btn');

if (loginForm && loginBtn) {
    const loginEmailInput = document.getElementById('login-email');
    const loginPasswordInput = document.getElementById('login-password');

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    function validateLoginForm() {
        const isEmailValid = emailRegex.test(loginEmailInput.value.trim());
        const isPasswordFilled = loginPasswordInput.value.trim().length >= 8;

        const isLoginValid = isEmailValid && isPasswordFilled;

        loginBtn.disabled = !isLoginValid;
        loginBtn.classList.toggle('enabled', isLoginValid);
    }

    loginEmailInput.addEventListener('input', validateLoginForm);
    loginPasswordInput.addEventListener('input', validateLoginForm);
}

// Password visibility toggle
document.addEventListener('DOMContentLoaded', function () {
    const togglePasswordBtn = document.getElementById('toggle-password');
    const passwordInput = document.getElementById('password');

    if (togglePasswordBtn && passwordInput) {
        togglePasswordBtn.addEventListener('click', function () {
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);

            // Update the show password button text
            togglePasswordBtn.textContent = type === 'password' ? 'Show' : 'Hide';
        });
    }
});

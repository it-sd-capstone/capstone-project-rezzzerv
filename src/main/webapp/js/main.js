document.addEventListener('DOMContentLoaded', () => {

    // Hardcoded for now
    const isAdmin = true;

    // This will eventually replace the hardcoded value above
    // const isAdmin = sessionStorage.getItem('isAdmin') === 'true';

    if (isAdmin) {
        const nav = document.querySelector('.nav-main');
        const li = document.createElement('li');
        const adminLink = document.createElement('a');
        adminLink.href = 'admin.html';
        adminLink.textContent = 'Admin Dashboard';
        li.appendChild(adminLink)
        nav.appendChild(li);
    }

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

        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

        function validateForm() {
            const isNameValid = nameInput.value.trim().length >= 2;
            const isLastNameValid = lastNameInput.value.trim().length >= 2;
            const isPhoneValid = phoneInput.value.trim().length >= 10;
            const isEmailValid = emailRegex.test(emailInput.value.trim());
            const isPasswordValid = passwordInput.value.length >= 8;
            const isPasswordMatch = passwordInput.value === confirmPasswordInput.value;

            toggleValidClass(nameInput, isNameValid);
            toggleValidClass(lastNameInput, isLastNameValid);
            toggleValidClass(phoneInput, isPhoneValid);
            toggleValidClass(emailInput, isEmailValid);
            toggleValidClass(passwordInput, isPasswordValid);
            toggleValidClass(confirmPasswordInput, isPasswordMatch);

            const isFormValid = isNameValid && isLastNameValid && isPhoneValid && isEmailValid && isPasswordValid && isPasswordMatch;

            registerBtn.disabled = !isFormValid;
            registerBtn.classList.toggle('enabled', isFormValid);
        }

        nameInput.addEventListener('input', validateForm);
        lastNameInput.addEventListener('input', validateForm);
        phoneInput.addEventListener('input', validateForm);
        emailInput.addEventListener('input', validateForm);
        passwordInput.addEventListener('input', validateForm);
        confirmPasswordInput.addEventListener('input', validateForm);
    }


    //Login Form Validation
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

            // OPTIONAL: We can add checkmarks if we want them on login too
            // toggleValidClass(loginEmailInput, isEmailValid);
            // toggleValidClass(loginPasswordInput, isPasswordFilled);
        }

        loginEmailInput.addEventListener('input', validateLoginForm);
        loginPasswordInput.addEventListener('input', validateLoginForm);
    }
});

document.addEventListener('DOMContentLoaded', () => {

    // Global HTML element variables
    const paymentForm    = document.getElementById('paymentForm');
    const payBtn         = document.getElementById('btnPay');
    const cardNameField  = document.getElementById('cardName');

    // User-friendly feedback for invalid input
    function pulseRed(input) {
        input.classList.add('invalid-pulse');
        input.addEventListener('animationend', () => {
            input.classList.remove('invalid-pulse');
        }, { once: true });
    }

        // This prevents non letters and non spaces from being typed into the name field.
        paymentForm.addEventListener('keypress', e => {
            if (e.target === cardNameField) {

                if (!/^[A-Za-z ]$/.test(e.key)) {
                    e.preventDefault();
                    pulseRed(cardNameField);
                }
            }
        });

        // This prevents non letters and non spaces from being pasted/autofilled into the name field.
        paymentForm.addEventListener('input', e => {
            if (e.target === cardNameField) {

                const cleaned = cardNameField.value.replace(/[^A-Za-z\s]/g, '');
                if (cleaned !== cardNameField.value) {
                    cardNameField.value = cleaned;
                    pulseRed(cardNameField);
                }
            }
        });
});

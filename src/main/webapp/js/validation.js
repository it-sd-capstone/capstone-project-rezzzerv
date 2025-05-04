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

    // (Optionally: your form-submit validation logic can go here)
    // e.g. adminForm.addEventListener('submit', …);
    //      editForm.addEventListener('submit', …);
});

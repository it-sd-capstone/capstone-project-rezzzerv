document.addEventListener('DOMContentLoaded', () => {
    initAddRoomForm();
    initEditModal();
    initEditUserModal()
    initDeleteConfirmation();
    initDeleteUserConfirmation()
    initFlash();
    initSectionToggle();
    initAddUserForm()
    initEditReservationModal();
    initDeleteReservationConfirmation();
    initRoomTypePrice();
});

function initRoomTypePrice() {
    const ROOM_PRICES = {
        Basic:        139.59,
        Premium:      219.59,
        Presidential: 499.59
    };

    const forms = [
        {typeId: 'roomType', priceId: 'price'},
        {typeId: 'editRoomType', priceId: 'editRoomPrice'}
    ];

    forms.forEach(({typeId, priceId}) => {
        const typeField  = document.getElementById(typeId);
        const priceField = document.getElementById(priceId);
        if (!typeField || !priceField) return;

        // style price field as plain text
        priceField.readOnly = true;
        priceField.style.border = 'none';
        priceField.style.backgroundColor = 'transparent';
        priceField.style.pointerEvents = 'none';
        priceField.style.padding = '0';
        priceField.style.fontSize = 'inherit';

        function updatePrice() {
            const price = ROOM_PRICES[typeField.value];
            priceField.value = price !== undefined ? price.toFixed(2) : '';
        }

        typeField.addEventListener('change', updatePrice);

        updatePrice();
    });
}

function initAddRoomForm() {
    const addRoomBtn = document.getElementById('addRoomBtn');
    const cancelBtn   = document.getElementById('cancelBtn');
    const formSection = document.getElementById('roomFormContainer');
    addRoomBtn.addEventListener('click', () => {
        const isOpen = formSection.classList.toggle('visible');
        addRoomBtn.textContent = isOpen ? 'Close Form' : 'Add New Room';
    });

    cancelBtn.addEventListener('click', () => {
        formSection.classList.remove('visible');
        addRoomBtn.textContent = 'Add New Room';
        clearForm(formSection);
    });
}

function initEditModal() {
    const modalOverlay   = document.getElementById('editOverlay');
    const editModal      = document.getElementById('editModal');
    const editCancelBtn  = document.getElementById('editCancelBtn');

    document.querySelectorAll('.editBtn').forEach(btn => {
        btn.addEventListener('click', () => {

            document.getElementById('editRoomId').value        = btn.dataset.id;
            document.getElementById('editRoomNumber').value    = btn.dataset.number;
            document.getElementById('editRoomType').value      = btn.dataset.type;
            const typeField = document.getElementById('editRoomType');
            if (typeField) {
                typeField.value = btn.dataset.type;
                typeField.dispatchEvent(new Event('change'));
            }
            document.getElementById('editRoomAvailable').value = btn.dataset.available;

            const availSelect = document.getElementById('editRoomAvailable');

            availSelect.value = btn.dataset.available;

            modalOverlay.style.display = 'flex';
            editModal.style.display    = 'flex';
        });
    });

    editCancelBtn.addEventListener('click', () => {
        modalOverlay.style.display = 'none';
        editModal.style.display    = 'none';
    });
}

function initEditUserModal() {
    const overlay = document.getElementById('editUserOverlay');
    const modal   = document.getElementById('editUserModal');
    const cancel  = document.getElementById('editUserCancelBtn');

    document.querySelectorAll('.editUserBtn').forEach(btn => {
        btn.addEventListener('click', () => {
            document.getElementById('editUserId').value = btn.dataset.id;
            document.getElementById('editFirstName').value = btn.dataset.firstName;
            document.getElementById('editLastName').value = btn.dataset.lastName;
            document.getElementById('editUserPhone').value = btn.dataset.phone;
            document.getElementById('editUserEmail').value = btn.dataset.email;
            document.getElementById('editUserPassword').value = btn.dataset.password;
            document.getElementById('editUserType').value = btn.dataset.userType;
            overlay.style.display = 'flex';
            modal.style.display   = 'flex';
        });
    });

    cancel.addEventListener('click', () => {
        overlay.style.display = 'none';
        modal.style.display   = 'none';
    });
}

function initEditReservationModal() {
    const overlay = document.getElementById('editReservationOverlay');
    const modal   = document.getElementById('editReservationModal');
    const cancel  = document.getElementById('cancelEditReservationBtn');

    document.querySelectorAll('.editReservationBtn').forEach(btn => {
        btn.addEventListener('click', () => {
            document.getElementById('editReservationId').value = btn.dataset.id;
            document.getElementById('editReservationStatus').value = btn.dataset.status;
            document.getElementById('editReservationCheckin').value = btn.dataset.checkin;
            document.getElementById('editReservationCheckout').value = btn.dataset.checkout;
            document.getElementById('editReservationUserId').value = btn.dataset.userId;
            document.getElementById('editReservationRoomId').value = btn.dataset.roomId;

            overlay.style.display = 'flex';
            modal.style.display   = 'flex';
        });
    });

    cancel.addEventListener('click', () => {
        overlay.style.display = 'none';
        modal.style.display   = 'none';
    });
}

function clearForm(id) {
    const form = document.getElementById(id);
    form.reset();
}

function initDeleteConfirmation() {
    const deleteOverlay  = document.getElementById('deleteOverlay');
    const deleteModal    = document.getElementById('deleteModal');
    const confirmDelete  = document.getElementById('confirmDeleteBtn');
    const cancelDelete   = document.getElementById('cancelDeleteBtn');
    let   currentForm    = null;

    document.querySelectorAll('.deleteBtn').forEach(btn => {
        btn.addEventListener('click', () => {
            currentForm = btn.closest('form');
            document.getElementById('deleteRoomNumber').textContent = btn.dataset.number;
            deleteOverlay.style.display = 'flex';
        });
    });

    cancelDelete.addEventListener('click', () => {
        deleteOverlay.style.display = 'none';
        deleteModal.style.display   = 'none';
    });

    confirmDelete.addEventListener('click', () => {
        deleteOverlay.style.display = 'none';
        deleteModal.style.display   = 'none';
        if (currentForm) currentForm.submit();
    });
}

function initDeleteUserConfirmation() {
    const overlay = document.getElementById('deleteUserOverlay');
    const modal   = document.getElementById('deleteUserModal');
    const confirm = document.getElementById('confirmDeleteUserBtn');
    const cancel  = document.getElementById('cancelDeleteUserBtn');
    let   formRef = null;

    document.querySelectorAll('.deleteUserBtn').forEach(btn => {
        btn.addEventListener('click', () => {
            formRef = btn.closest('form');
            document.getElementById('deleteUserName').textContent =
                btn.dataset.firstName + ' ' + btn.dataset.lastName;
            overlay.style.display = 'flex';
            modal.style.display   = 'flex';
        });
    });

    cancel.addEventListener('click', () => {
        overlay.style.display = 'none';
        modal.style.display   = 'none';
    });

    confirm.addEventListener('click', () => {
        overlay.style.display = 'none';
        modal.style.display   = 'none';
        if (formRef) formRef.submit();
    });
}

function initDeleteReservationConfirmation() {
    const overlay = document.getElementById('deleteReservationOverlay');
    const modal   = document.getElementById('deleteReservationModal');
    const confirm = document.getElementById('confirmDeleteReservationBtn');
    const cancel  = document.getElementById('cancelDeleteReservationBtn');
    let formRef    = null;

    document.querySelectorAll('.deleteReservationBtn').forEach(btn => {
        btn.addEventListener('click', () => {
            formRef = btn.closest('form');
            document.getElementById('deleteReservationId').textContent = btn.dataset.id;
            overlay.style.display = 'flex';
            modal.style.display   = 'flex';
        });
    });

    cancel.addEventListener('click', () => {
        overlay.style.display = 'none';
        modal.style.display   = 'none';
    });

    confirm.addEventListener('click', () => {
        overlay.style.display = 'none';
        modal.style.display   = 'none';
        if (formRef) formRef.submit();
    });
}

function initFlash() {
    const flash = document.querySelector('.flash-message');
    if (!flash) return;

    const closeBtn = flash.querySelector('.flash-close');
    if (closeBtn) {
        closeBtn.addEventListener('click', () => flash.remove());
    }

    setTimeout(() => {
        if (flash.parentNode) flash.remove();
    }, 7000);
}

function initSectionToggle() {
    const sectionSelect = document.getElementById('sectionSelect');
    if (!sectionSelect) return;

    const sections = {
        rooms: document.getElementById('roomsSection'),
        users: document.getElementById('usersSection'),
        reservations: document.getElementById('reservationsSection'),
    };

    function show(name) {
        Object.entries(sections).forEach(([key, el]) => {
            el.style.display = key === name ? 'block' : 'none';
        });
    }

    show(sectionSelect.value);

    sectionSelect.addEventListener('change', e => {
        const sel = sectionSelect.value;
        window.location.href = `${window.location.pathname}?section=${sel}`;
    });
}

function initAddUserForm() {
    const addUserBtn    = document.getElementById('addUserBtn');
    const cancelUserBtn = document.getElementById('cancelUserBtn');
    const userFormSection = document.getElementById('userFormContainer');

    addUserBtn.addEventListener('click', () => {
        const isOpen = userFormSection.classList.toggle('visible');
        addUserBtn.textContent = isOpen ? 'Close Form' : 'Add New User';
    });

    cancelUserBtn.addEventListener('click', () => {
        userFormSection.classList.remove('visible');
        addUserBtn.textContent = 'Add New User';
        clearForm('userFormContainer');
    });
}

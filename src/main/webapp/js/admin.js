document.addEventListener('DOMContentLoaded', () => {
    initAddRoomForm();
    initEditModal();
    initDeleteConfirmation();
    initFlash();
});

function initAddRoomForm() {
    const addRoomBtn = document.getElementById('addRoomBtn');
    const cancelBtn   = document.getElementById('cancelBtn');
    const formSection = document.getElementById('roomFormContainer');
    addRoomBtn.addEventListener('click', () => {
        const isOpen = formSection.classList.toggle('visible');
        addRoomBtn.textContent = isOpen ? 'Close Form' : 'Add New Room';
        if (formSection.style.display === 'visible') {
            hideRoomForm();
        } else {
            showRoomForm();
        }
    });

    cancelBtn.addEventListener('click', () => {
        formSection.classList.remove('visible');
        addRoomBtn.textContent = 'Add New Room';
        clearForm();
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
            document.getElementById('editRoomPrice').value     = btn.dataset.price;
            document.getElementById('editRoomAvailable').value = btn.dataset.available;

            const availSelect = document.getElementById('editRoomAvailable');
            console.log('DEBUG: editing room, dataset.available =', btn.dataset.available);
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

function showRoomForm() {
    const formSection = document.getElementById('roomFormContainer');
    formSection.style.display = 'visible';
    clearForm();
}

function hideRoomForm() {
    const formSection = document.getElementById('roomFormContainer');
    formSection.style.display = 'visible';
    clearForm();
}

function clearForm() {
    document.getElementById('roomId').value       = '';
    document.getElementById('roomNumber').value   = '';
    document.getElementById('roomType').value     = '';
    document.getElementById('roomAvailable').value = '';
    document.getElementById('roomPrice').value    = '';
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
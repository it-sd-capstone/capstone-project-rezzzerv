document.addEventListener('DOMContentLoaded', () => {

    const addRoomBtn = document.getElementById('addRoomBtn');
    addRoomBtn.addEventListener('click', () => {
        showRoomForm();
    });

    const cancelBtn = document.getElementById('cancelBtn');
    cancelBtn.addEventListener('click', () => {
        hideRoomForm();
    });
});

function showRoomForm() {
    const formSection = document.getElementById('roomFormContainer');

    formSection.style.display = 'block';
    clearForm();
}

function hideRoomForm() {
    const formSection = document.getElementById('roomFormContainer');
    formSection.style.display = 'none';
    clearForm();
}

function clearForm() {
    document.getElementById('roomId').value = '';
    document.getElementById('roomNumber').value = '';
    document.getElementById('roomType').value = '';
    document.getElementById('roomPrice').value = '';
}


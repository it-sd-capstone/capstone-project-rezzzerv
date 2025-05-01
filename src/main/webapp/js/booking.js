// Get room prices from data attributes
const roomPrices = {
    Basic: parseFloat(document.getElementById('roomPrices').getAttribute('data-basic-price')),
    Premium: parseFloat(document.getElementById('roomPrices').getAttribute('data-premium-price')),
    Presidential: parseFloat(document.getElementById('roomPrices').getAttribute('data-presidential-price'))
};

// Function to select a room type
function selectRoom(roomType) {
    // Update hidden input
    document.getElementById('roomType').value = roomType;

    // Update UI
    const roomOptions = document.querySelectorAll('.room-option');
    roomOptions.forEach(option => {
        if (option.getAttribute('data-room-type') === roomType) {
            option.classList.add('selected');
        } else {
            option.classList.remove('selected');
        }
    });

    // Update summary
    updateBookingSummary();
}

// Function to calculate number of nights
function calculateNights(checkIn, checkOut) {
    const checkInDate = new Date(checkIn);
    const checkOutDate = new Date(checkOut);
    const timeDiff = checkOutDate.getTime() - checkInDate.getTime();
    return Math.ceil(timeDiff / (1000 * 3600 * 24));
}

// Function to update booking summary
function updateBookingSummary() {
    const checkIn = document.getElementById('checkIn').value;
    const checkOut = document.getElementById('checkOut').value;
    const guests = document.getElementById('guests').value;
    const roomType = document.getElementById('roomType').value;

    if (checkIn && checkOut && roomType) {
        const nights = calculateNights(checkIn, checkOut);
        const pricePerNight = roomPrices[roomType];
        const total = nights * pricePerNight;

        document.getElementById('summaryCheckIn').textContent = checkIn;
        document.getElementById('summaryCheckOut').textContent = checkOut;
        document.getElementById('summaryGuests').textContent = guests;
        document.getElementById('summaryRoomType').textContent = roomType;
        document.getElementById('summaryNights').textContent = nights;
        document.getElementById('summaryTotal').textContent = total.toFixed(2);

        document.getElementById('bookingSummary').style.display = 'block';
    }
}

// Event listeners
document.getElementById('checkIn').addEventListener('change', function() {
    // Ensure checkout is after checkin
    const checkIn = new Date(this.value);
    const checkOut = new Date(document.getElementById('checkOut').value);

    if (checkOut <= checkIn) {
        // Set checkout to day after checkin
        checkIn.setDate(checkIn.getDate() + 1);
        const year = checkIn.getFullYear();
        const month = String(checkIn.getMonth() + 1).padStart(2, '0');
        const day = String(checkIn.getDate()).padStart(2, '0');
        document.getElementById('checkOut').value = `${year}-${month}-${day}`;
    }

    updateBookingSummary();
});

document.getElementById('checkOut').addEventListener('change', updateBookingSummary);
document.getElementById('guests').addEventListener('change', updateBookingSummary);

// Form submission
document.getElementById('bookingForm').addEventListener('submit', function(e) {
    const roomType = document.getElementById('roomType').value;
    if (!roomType) {
        e.preventDefault();
        alert('Please select a room type');
    }
});

// Initialize with Basic room selected
window.onload = function() {
    selectRoom('Basic');
};

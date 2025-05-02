document.addEventListener('DOMContentLoaded', function() {
    // Get form elements
    const checkInInput = document.getElementById('checkIn');
    const checkOutInput = document.getElementById('checkOut');
    const roomTypeInput = document.getElementById('roomType');
    const roomOptions = document.querySelectorAll('.room-option');

    // Get summary elements
    const summaryCheckIn = document.getElementById('summaryCheckIn');
    const summaryCheckOut = document.getElementById('summaryCheckOut');
    const summaryRoomType = document.getElementById('summaryRoomType');
    const summaryNights = document.getElementById('summaryNights');
    const summaryTotal = document.getElementById('summaryTotal');
    const bookingSummary = document.getElementById('bookingSummary');
    const roomPricesElement = document.getElementById('roomPrices');

    // Check if we have all required elements
    if (!checkInInput || !checkOutInput || !roomTypeInput || !roomPricesElement ||
        !summaryCheckIn || !summaryCheckOut || !summaryRoomType ||
        !summaryNights || !summaryTotal || !bookingSummary) {
        return; // Exit early if elements are missing
    }

    // Get room prices from data attributes
    const roomPrices = {};
    try {
        roomPrices.Basic = parseFloat(roomPricesElement.getAttribute('data-basic-price'));
        roomPrices.Premium = parseFloat(roomPricesElement.getAttribute('data-premium-price'));
        roomPrices.Presidential = parseFloat(roomPricesElement.getAttribute('data-presidential-price'));
    } catch (e) {
        // Fallback to default prices if there's an error
        roomPrices.Basic = 139.59;
        roomPrices.Premium = 219.59;
        roomPrices.Presidential = 499.59;
    }

    // Add event listeners safely
    if (checkInInput) {
        checkInInput.addEventListener('change', updateBookingSummary);
    }

    if (checkOutInput) {
        checkOutInput.addEventListener('change', updateBookingSummary);
    }

    // Function to select a room
    window.selectRoom = function(roomType) {
        if (!roomTypeInput) {
            return;
        }

        // Update hidden input
        roomTypeInput.value = roomType;

        // Update UI
        roomOptions.forEach(option => {
            if (option.getAttribute('data-room-type') === roomType) {
                option.classList.add('selected');
            } else {
                option.classList.remove('selected');
            }
        });

        // Update summary
        updateBookingSummary();
    };

    // Helper function to parse date string correctly
    function parseDate(dateString) {
        // Split the date string into parts
        const parts = dateString.split('-');
        // Create a new date with the parts (year, month-1, day)
        // Note: JavaScript months are 0-indexed (0=January, 11=December)
        return new Date(parts[0], parts[1] - 1, parts[2]);
    }

    // Function to update booking summary
    function updateBookingSummary() {
        if (!checkInInput || !checkOutInput || !roomTypeInput) {
            return;
        }

        // Get values - use our helper function to avoid timezone issues
        const checkIn = parseDate(checkInInput.value);
        const checkOut = parseDate(checkOutInput.value);
        const roomType = roomTypeInput.value;

        // Calculate nights
        const nights = Math.max(1, Math.round((checkOut - checkIn) / (1000 * 60 * 60 * 24)));

        // Format dates for display
        const options = { weekday: 'short', month: 'short', day: 'numeric', year: 'numeric' };
        const checkInFormatted = checkIn.toLocaleDateString('en-US', options);
        const checkOutFormatted = checkOut.toLocaleDateString('en-US', options);

        // Update summary elements
        summaryCheckIn.textContent = checkInFormatted;
        summaryCheckOut.textContent = checkOutFormatted;
        summaryNights.textContent = nights;

        // Only update room type and total if a room is selected
        if (roomType) {
            summaryRoomType.textContent = roomType;
            const roomPrice = roomPrices[roomType];
            const total = (roomPrice * nights).toFixed(2);
            summaryTotal.textContent = total;

            // Show booking summary
            bookingSummary.style.display = 'block';
        } else {
            summaryRoomType.textContent = 'Not selected';
            summaryTotal.textContent = '0.00';
        }

        // Validate dates
        if (checkOut <= checkIn) {
            alert('Check-out date must be after check-in date');
            // Set checkout to day after checkin
            const newCheckout = new Date(checkIn);
            newCheckout.setDate(newCheckout.getDate() + 1);
            // Format the date as YYYY-MM-DD for the input
            const month = (newCheckout.getMonth() + 1).toString().padStart(2, '0');
            const day = newCheckout.getDate().toString().padStart(2, '0');
            checkOutInput.value = `${newCheckout.getFullYear()}-${month}-${day}`;
            updateBookingSummary();
        }
    }

    // Initialize with first room selected
    if (roomOptions.length > 0) {
        const firstRoomType = roomOptions[0].getAttribute('data-room-type');
        selectRoom(firstRoomType);
    }
});

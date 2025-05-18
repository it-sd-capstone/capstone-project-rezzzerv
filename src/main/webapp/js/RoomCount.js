document.addEventListener('DOMContentLoaded', () => {

    initRoomCounts();
}) ;

function initRoomCounts() {
    const checkIn  = document.getElementById('checkIn');
    const checkOut = document.getElementById('checkOut');
    if (!checkIn || !checkOut) return;

    const spanBasic       = document.getElementById('countBasic');
    const spanPremium     = document.getElementById('countPremium');
    const spanPresidential= document.getElementById('countPresidential');

    function updateCounts() {
        const inDate  = checkIn.value;
        const outDate = checkOut.value;
        if (!inDate || !outDate) return;

        fetch(`/rezzzerv/roomCounts?checkIn=${inDate}&checkOut=${outDate}`)
            .then(res => res.json())
            .then(data => {
                spanBasic.textContent = data.basic;
                spanPremium.textContent = data.premium;
                spanPresidential.textContent = data.presidential;

                toggleSoldOut('Basic', data.basic);
                toggleSoldOut('Premium', data.premium);
                toggleSoldOut('Presidential', data.presidential);

            })
            .catch(err => console.error('RoomCounts error:', err));
    }

    checkIn.addEventListener('change', updateCounts);
    checkOut.addEventListener('change', updateCounts);

    updateCounts();
}

function toggleSoldOut(type, count) {
    const element = document.querySelector(
        '.room-option[data-room-type="' + type + '"]'
    );
    if (!element) {
        return;
    }

    if (count <= 0) {
        element.classList.add('unavailable');
    } else {
        element.classList.remove('unavailable');
    }
}


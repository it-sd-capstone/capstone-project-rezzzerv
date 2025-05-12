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
                spanBasic.textContent        = data.basic;
                spanPremium.textContent      = data.premium;
                spanPresidential.textContent = data.presidential;
            })
            .catch(err => console.error('RoomCounts error:', err));
    }

    checkIn.addEventListener('change', updateCounts);
    checkOut.addEventListener('change', updateCounts);

    updateCounts();
}

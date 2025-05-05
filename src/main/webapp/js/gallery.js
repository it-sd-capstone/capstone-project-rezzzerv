// Wait for the DOM to be fully loaded
document.addEventListener('DOMContentLoaded', function() {
    console.log("Gallery script loaded");

    // Get all thumbnail images
    const thumbnails = document.querySelectorAll('.thumbnail-images img');

    // Add click event listeners to each thumbnail
    thumbnails.forEach(thumbnail => {
        thumbnail.addEventListener('click', function() {
            // Get the room ID from the closest room-card parent
            const roomCard = this.closest('.room-card');
            if (roomCard) {
                const roomId = roomCard.id;
                // Get the main image within this room card
                const mainImage = roomCard.querySelector('.main-image');
                if (mainImage) {
                    // Update the main image source
                    mainImage.src = this.src;
                    console.log(`Changed image for ${roomId} to ${this.src}`);
                }
            }
        });
        // Add visual indicator that thumbnails are clickable
        thumbnail.style.cursor = 'pointer';
    });
});

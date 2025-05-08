document.addEventListener('DOMContentLoaded', () => {

    // Dropdown menu functionality
    const userDropdown = document.querySelector('.dropdown');
    if (userDropdown) {
        const userNameLink = userDropdown.querySelector('.user-name');
        const dropdownContent = userDropdown.querySelector('.dropdown-content');

        // Force hide dropdown initially
        if (dropdownContent) {
            dropdownContent.style.display = 'none';

            // Toggle dropdown on username click
            userNameLink.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();

                // Toggle display
                if (dropdownContent.style.display === 'block') {
                    dropdownContent.style.display = 'none';
                } else {
                    dropdownContent.style.display = 'block';
                }
            });

            // Close dropdown when clicking outside
            document.addEventListener('click', function(e) {
                if (!userDropdown.contains(e.target)) {
                    dropdownContent.style.display = 'none';
                }
            });
        }
    }
});

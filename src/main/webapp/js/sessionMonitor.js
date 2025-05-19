// Session monitoring script for all authenticated users
(function() {
    // Check session status every 10 seconds
    const CHECK_INTERVAL = 10000;

    // Store the last known logout time and user ID
    let lastKnownLogout = getCookieValue('lastLogout') || 0;
    let lastLogoutUserId = getCookieValue('logoutUserId') || '';
    let currentUserId = ''; // Will be set from the page

    // Get the current user ID from a data attribute in the body tag
    function initSessionMonitor() {
        const body = document.body;
        if (body.dataset.userId) {
            currentUserId = body.dataset.userId;
            startMonitoring();
        }
    }

    function startMonitoring() {
        // Initial check
        checkSessionStatus();

        // Set up periodic checking
        setInterval(checkSessionStatus, CHECK_INTERVAL);
    }

    function checkSessionStatus() {
        // Check if logout cookie has changed
        const currentLogout = getCookieValue('lastLogout') || 0;
        const logoutUserId = getCookieValue('logoutUserId') || '';

        // Only redirect if the logout is newer AND it's for the current user
        if (currentLogout > lastKnownLogout &&
            lastKnownLogout > 0 &&
            logoutUserId === currentUserId) {
            // Logout happened in another window for this user
            window.location.href = 'login.jsp?sessionExpired=true';
            return;
        }

        lastKnownLogout = currentLogout;
        lastLogoutUserId = logoutUserId;
    }

    function getCookieValue(name) {
        const match = document.cookie.match(new RegExp('(^| )' + name + '=([^;]+)'));
        return match ? match[2] : null;
    }

    // Initialize when the DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initSessionMonitor);
    } else {
        initSessionMonitor();
    }
})();

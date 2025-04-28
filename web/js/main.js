document.addEventListener('DOMContentLoaded', () => {

    // Hardcoded for now
    const isAdmin = true;

    // This will eventually replace the hardcoded value above
    // const isAdmin = sessionStorage.getItem('isAdmin') === 'true';

    if (isAdmin) {
        const nav = document.querySelector('.nav-main');
        const li = document.createElement('li');
        const adminLink = document.createElement('a');
        adminLink.href = 'admin.html';
        adminLink.textContent = 'Admin Dashboard';
        li.appendChild(adminLink)
        nav.appendChild(li);
    }
});

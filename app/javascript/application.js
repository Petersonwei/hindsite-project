// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "./toast"

// Mobile menu toggle functionality
document.addEventListener('turbo:load', () => {
  // Initialize mobile menu
  initMobileMenu();
  
  // Initialize other interactive elements
  initInteractiveElements();
});

function initMobileMenu() {
  const mobileMenuToggle = document.querySelector('.mobile-menu-toggle');
  const mobileMenu = document.querySelector('.mobile-menu');
  const mobileMenuClose = document.querySelector('.mobile-menu-close');
  
  if (mobileMenuToggle && mobileMenu) {
    mobileMenuToggle.addEventListener('click', () => {
      mobileMenu.classList.add('active');
      document.body.style.overflow = 'hidden';
    });
    
    if (mobileMenuClose) {
      mobileMenuClose.addEventListener('click', () => {
        mobileMenu.classList.remove('active');
        document.body.style.overflow = '';
      });
    }
  }
}

function initInteractiveElements() {
  // Show welcome toast for new sessions
  if (!sessionStorage.getItem('welcomeShown') && document.querySelector('.dashboard, .section')) {
    setTimeout(() => {
      window.showToast('info', 'Welcome to Hindsite', 'Navigate through your organizations and manage your mining operations efficiently.', 6000);
      sessionStorage.setItem('welcomeShown', 'true');
    }, 1000);
  }
  
  // Add hover effects to cards
  const cards = document.querySelectorAll('.card');
  cards.forEach(card => {
    card.addEventListener('mouseenter', function() {
      this.style.transform = 'translateY(-5px)';
      this.style.boxShadow = 'var(--shadow-md)';
    });
    card.addEventListener('mouseleave', function() {
      this.style.transform = '';
      this.style.boxShadow = '';
    });
  });
}

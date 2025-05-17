// Toast notification system
document.addEventListener('DOMContentLoaded', () => {
  initToastSystem();
});

function initToastSystem() {
  // Create toast container if it doesn't exist
  let toastContainer = document.querySelector('.toast-container');
  if (!toastContainer) {
    toastContainer = document.createElement('div');
    toastContainer.classList.add('toast-container');
    document.body.appendChild(toastContainer);
  }

  // Listen for custom toast events
  document.addEventListener('hindsite:toast', (e) => {
    showToast(e.detail.type, e.detail.title, e.detail.message, e.detail.duration);
  });

  // Add method to window for direct usage
  window.showToast = (type, title, message, duration = 5000) => {
    showToast(type, title, message, duration);
  };
}

function showToast(type = 'info', title, message, duration = 5000) {
  // Create toast container if it doesn't exist
  let toastContainer = document.querySelector('.toast-container');
  if (!toastContainer) {
    toastContainer = document.createElement('div');
    toastContainer.classList.add('toast-container');
    document.body.appendChild(toastContainer);
  }

  // Create toast element
  const toast = document.createElement('div');
  toast.classList.add('toast', `toast-${type}`);

  // Define icons based on toast type
  const icons = {
    success: '<i class="fas fa-check-circle toast-icon" style="color: hsl(142, 76%, 36%);"></i>',
    error: '<i class="fas fa-times-circle toast-icon" style="color: hsl(0, 84%, 60%);"></i>',
    warning: '<i class="fas fa-exclamation-triangle toast-icon" style="color: hsl(38, 92%, 50%);"></i>',
    info: '<i class="fas fa-info-circle toast-icon" style="color: hsl(221, 83%, 53%);"></i>'
  };

  // Create toast content
  toast.innerHTML = `
    ${icons[type] || icons.info}
    <div class="toast-content">
      ${title ? `<div class="toast-title">${title}</div>` : ''}
      ${message ? `<div class="toast-message">${message}</div>` : ''}
    </div>
    <button class="toast-close" aria-label="Close toast">
      <i class="fas fa-times"></i>
    </button>
  `;

  // Add to container
  toastContainer.appendChild(toast);

  // Set auto-remove timeout
  const timeoutId = setTimeout(() => {
    removeToast(toast);
  }, duration);

  // Add close button listener
  const closeButton = toast.querySelector('.toast-close');
  closeButton.addEventListener('click', () => {
    clearTimeout(timeoutId);
    removeToast(toast);
  });
}

function removeToast(toast) {
  // Add exit animation class
  toast.style.opacity = '0';
  toast.style.transform = 'translateX(100%)';
  toast.style.transition = 'opacity 0.3s ease, transform 0.3s ease';
  
  // Remove after animation
  setTimeout(() => {
    if (toast.parentNode) {
      toast.parentNode.removeChild(toast);
    }
  }, 300);
} 
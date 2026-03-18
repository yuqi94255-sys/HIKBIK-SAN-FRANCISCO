// Share utilities for National Forests
export interface ShareData {
  title: string;
  text: string;
  url?: string;
}

// Check if Web Share API is available
export function canShare(): boolean {
  return typeof navigator !== 'undefined' && 'share' in navigator;
}

// Share using Web Share API
export async function shareContent(data: ShareData): Promise<boolean> {
  if (!canShare()) {
    return false;
  }

  try {
    await navigator.share({
      title: data.title,
      text: data.text,
      url: data.url || window.location.href
    });
    return true;
  } catch (error) {
    // User cancelled or error occurred
    if ((error as Error).name !== 'AbortError') {
      console.error('Error sharing:', error);
    }
    return false;
  }
}

// Copy to clipboard fallback
export async function copyToClipboard(text: string): Promise<boolean> {
  try {
    if (navigator.clipboard && navigator.clipboard.writeText) {
      await navigator.clipboard.writeText(text);
      return true;
    } else {
      // Fallback for older browsers
      const textArea = document.createElement('textarea');
      textArea.value = text;
      textArea.style.position = 'fixed';
      textArea.style.left = '-999999px';
      document.body.appendChild(textArea);
      textArea.focus();
      textArea.select();
      
      try {
        const successful = document.execCommand('copy');
        document.body.removeChild(textArea);
        return successful;
      } catch (err) {
        document.body.removeChild(textArea);
        return false;
      }
    }
  } catch (error) {
    console.error('Error copying to clipboard:', error);
    return false;
  }
}

// Generate shareable text for forest
export function generateShareText(forestName: string, state: string, nearestCity?: string): ShareData {
  const location = nearestCity ? `${state} • ${nearestCity}` : state;
  return {
    title: forestName,
    text: `Check out ${forestName} in ${location}! 🌲 Explore this beautiful national forest.`,
    url: window.location.href
  };
}

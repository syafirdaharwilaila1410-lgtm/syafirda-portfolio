
"use strict";

document.addEventListener("DOMContentLoaded", () => {
  const languageToggle = document.getElementById("languageToggle");
  const cvButton = document.getElementById("cvButton");
  const menuToggle = document.getElementById("menuToggle");
  const navLinks = document.getElementById("navLinks");
  const currentYear = document.getElementById("currentYear");

  // Set the current year automatically.
  if (currentYear) {
    currentYear.textContent = new Date().getFullYear();
  }

  // Default language.
  let currentLanguage = "id";

  // Update all elements that have data-id and data-en attributes.
  function setLanguage(language) {
    currentLanguage = language;
    document.documentElement.lang = language;

    document.querySelectorAll("[data-id][data-en]").forEach((element) => {
      const translatedText = element.dataset[language];

      if (translatedText !== undefined) {
        element.innerHTML = translatedText;
      }
    });

    // Update the language button.
    if (languageToggle) {
      languageToggle.textContent = language === "id" ? "EN ↗" : "ID ↗";
      languageToggle.setAttribute(
        "aria-label",
        language === "id"
          ? "Switch website language to English"
          : "Ubah bahasa website ke Indonesia"
      );
    }

    // Use the matching CV file for the selected language.
    if (cvButton) {
      const cvPath =
        language === "id"
          ? "assets/cv-indonesia.pdf"
          : "assets/cv-english.pdf";

      cvButton.href = cvPath;
      cvButton.setAttribute("download", "");
    }

    // Update the browser tab title.
    document.title =
      language === "id"
        ? "Syafirda Harwi Laila | Portfolio Data"
        : "Syafirda Harwi Laila | Data Portfolio";

    // Close the mobile menu after switching language.
    closeMenu();
  }

  // Toggle between Indonesian and English.
  if (languageToggle) {
    languageToggle.addEventListener("click", () => {
      const nextLanguage = currentLanguage === "id" ? "en" : "id";
      setLanguage(nextLanguage);
    });
  }

  // Mobile navigation.
  function closeMenu() {
    if (!navLinks || !menuToggle) return;

    navLinks.classList.remove("open");
    menuToggle.setAttribute("aria-expanded", "false");
    menuToggle.setAttribute("aria-label", "Open navigation");
  }

  if (menuToggle && navLinks) {
    menuToggle.addEventListener("click", () => {
      const isOpen = navLinks.classList.toggle("open");

      menuToggle.setAttribute("aria-expanded", String(isOpen));
      menuToggle.setAttribute(
        "aria-label",
        isOpen ? "Close navigation" : "Open navigation"
      );
    });

    // Close the menu when a navigation link is selected.
    navLinks.querySelectorAll('a[href^="#"]').forEach((link) => {
      link.addEventListener("click", closeMenu);
    });

    // Close the menu when the user presses Escape.
    document.addEventListener("keydown", (event) => {
      if (event.key === "Escape") {
        closeMenu();
      }
    });

    // Reset mobile menu when returning to desktop layout.
    window.addEventListener("resize", () => {
      if (window.innerWidth > 720) {
        closeMenu();
      }
    });
  }

  // Start in Indonesian.
  setLanguage("id");
});


const cvDropdownButton = document.getElementById("cvDropdownButton");
const cvDropdownMenu = document.getElementById("cvDropdownMenu");

if (cvDropdownButton && cvDropdownMenu) {
  cvDropdownButton.addEventListener("click", () => {
    const isExpanded =
      cvDropdownButton.getAttribute("aria-expanded") === "true";

    cvDropdownButton.setAttribute("aria-expanded", String(!isExpanded));
    cvDropdownMenu.hidden = isExpanded;
  });

  document.addEventListener("click", (event) => {
    if (!event.target.closest(".cv-dropdown")) {
      cvDropdownButton.setAttribute("aria-expanded", "false");
      cvDropdownMenu.hidden = true;
    }
  });
}
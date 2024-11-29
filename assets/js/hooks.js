let Hooks = {};

// Define the Confetti hook that will handle our confetti animations
Hooks.Confetti = {
  // mounted runs when the element with this hook is added to the page
  mounted() {
    // Listen for the trigger-confetti event that our LiveView will send
    this.handleEvent("trigger-confetti", ({ type = "basic" }) => {
      // Different animation patterns based on the type parameter
      switch (type) {
        case "basic":
          window.confetti({
            particleCount: 100, // How many pieces of confetti
            spread: 70, // How spread out they are
            origin: { y: 0.6 }, // Where they start from (0.6 is about middle of screen)
          });
          break;

        case "celebration":
          // First burst of confetti
          window.confetti({
            particleCount: 200,
            spread: 100,
            origin: { y: 0.6 },
          });

          // Second burst after a small delay for more impact
          setTimeout(() => {
            window.confetti({
              particleCount: 200,
              spread: 100,
              origin: { y: 0.6 },
            });
          }, 250);
          break;

        case "shower":
          // Create a 3-second confetti shower
          const end = Date.now() + 3 * 1000;
          const colors = ["#ff0000", "#00ff00", "#0000ff"];

          // This function calls itself repeatedly to create a continuous effect
          (function frame() {
            // Confetti from the left side
            window.confetti({
              particleCount: 2,
              angle: 60,
              spread: 55,
              origin: { x: 0 },
              colors: colors,
            });

            // Confetti from the right side
            window.confetti({
              particleCount: 2,
              angle: 120,
              spread: 55,
              origin: { x: 1 },
              colors: colors,
            });

            // Keep creating confetti until we reach our end time
            if (Date.now() < end) {
              requestAnimationFrame(frame);
            }
          })();
          break;
      }
    });
  },
};

// Make our hooks available to import in app.js
export default Hooks;

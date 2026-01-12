import type { Plugin } from "@opencode-ai/plugin";
import path from "path";

export const GhosttyNotificationPlugin: Plugin = async ({ $, client, directory }) => {
  const projectName = path.basename(directory);

  /**
   * Checks if Ghostty is focused AND the current window/tab matches this session
   */
  const isThisSessionFocused = async (sessionTitle?: string): Promise<boolean> => {
    try {
      // Check if Ghostty is the frontmost app
      const frontApp =
        await $`osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true'`.text();
      
      if (frontApp.trim().toLowerCase() !== "ghostty") {
        return false;
      }

      // Check if the front Ghostty window/tab matches this specific session
      const windowTitle =
        await $`osascript -e 'tell application "System Events" to tell process "ghostty" to get name of front window'`.text();
      
      const title = windowTitle.trim();
      
      // Must start with "OC |" (OpenCode indicator)
      if (!title.startsWith("OC |")) {
        return false;
      }
      
      // If we have a session title, check if it's contained in the window title
      if (sessionTitle) {
        // Window title format: "OC | Session title here..."
        // Extract first few words of session title to match (since window title truncates)
        const sessionWords = sessionTitle.split(" ").slice(0, 3).join(" ");
        return title.includes(sessionWords);
      }
      
      // Fallback: check if project name is in the title
      return title.includes(projectName);
    } catch {
      return true; // Assume focused if check fails
    }
  };

  return {
    event: async ({ event }) => {
      if (event.type === "session.idle") {
        const response = await client.session.get({ path: { id: event.properties.sessionID } });
        const session = response.data;
        const displayName = session?.title || projectName;
        
        const focused = await isThisSessionFocused(session?.title);

        if (!focused) {
          const statusMap: Record<string, string> = {
            idle: "Ready for your input",
            pending: "Waiting...",
            running: "Still working...",
            error: "Something went wrong",
          };
          const statusMessage = statusMap[session?.status || "idle"] || "Ready for your input";
          
          await $`osascript -e 'display notification "${statusMessage}" with title "${displayName}" sound name "Blow"'`;
        }
      }
    },
  };
};

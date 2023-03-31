function onCreate()
    debugPrint('Please disable "Camera Shake" in options if you are at risk of seizures')
    debugPrint('This song contains "Camera Shake".')
    debugPrint('Epilepsy / Photosensitivity Warning:')
end

function opponentNoteHit()
            health = getProperty('health')
       if getProperty('health') > 1.5 then
           setProperty('health', health- 0.02);
   end
end
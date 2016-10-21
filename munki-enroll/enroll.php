<?php

if((isset($_GET["serial"])) AND (isset($_GET["displayname"])) AND (isset($_GET["template"]))){

    // Get the variables passed by the enroll script
    $serial = $_GET["serial"];
    $displayname = $_GET["displayname"];
    $template = $_GET["template"];

    // Specify the template source to be copied as an individual template
    if($template == "desktop"){
    
            $source="../manifests/desktop_template";

        } elseif($template == "laptop") {
            
            $source="../manifests/laptop_template";
        
        } else {
        
            $source="";
        
        }

    // Double-check there is a source to copy from
    if(($source!="") AND (file_exists($source))){

        // Create destination
        $destination="../manifests/" . $serial;

        // Check if manifest already exists for this machine
        if ( file_exists($destination) ){
            
                // The manifest already exists. Nothing to do.
                echo "Computer manifest " . $serial . " already exists.";
        
            } else {
            
                // Create the manifest
                echo "Computer manifest does not exist. Will create " . $destination;
                copy($source, $destination);

                // Add in the proper display name
                // Comment out this command if you aren't using macOS, which you likely aren't.
                // For Linux, you can put in a placeholder in the template to copy and then use the sed command to find/replace text
                // Will probably go this route for future versions, so it's not tied to macOS
                shell_exec('/usr/libexec/PlistBuddy -c "Add :display_name string ' . "'" . $displayname . "'" . '" ' . $destination);
            }

        // End checking for source manifest existence
        } else {
        
            echo "Cannot create manifest. The source template to copy from does not exist.";
        
        }

    // End checking for GET variables
    } else {
        echo "Cannot create manifest. Missing one or more variables. Need serial number, display name, and template";
    }

?>

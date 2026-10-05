// measure save roi set macro to save secs on the hour -YML

Dialog.create("saving info");
Dialog.addString("Image info: Date_Dataset","YYYYMMDD-data");
Dialog.show();
title1= Dialog.getString();

roiManager("Deselect");
roiManager("Save", "C:/Users/loydy/Collabs_images/Phagocytosis_TP/Phg_eff/Analysis_YML/MaskedImages/"+title1+"_RoiSet.zip");

selectImage(title1+"_bead_exclusions_magenta_igg_green_masks.tif");
roiManager("multi-measure measure_all");
saveAs("Results", "C:/Users/loydy/Collabs_images/Phagocytosis_TP/Phg_eff/Analysis_YML/MaskedImages/"+title1+"_Results.csv");

roiManager("Deselect");
roiManager("Delete");

run("Close");
run("Close");
run("Close");
run("Close");
run("Close");
run("Close");
run("Close");
run("Close");
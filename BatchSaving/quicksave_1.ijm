// measure save roi set macro to save secs on the hour -YML

Dialog.create("saving info");
Dialog.addString("Image info: Date_Dataset","YYYYMMDD-data");
Dialog.show();
title1= Dialog.getString();

roiManager("Deselect");
Folder= "C:/Users/loydy/Collabs_images/Phagocytosis_TP/Phg_eff/Analysis_YML/20250904_ROIs/";
roiManager("Open", Folder+title1+"_RoiSet.zip");

selectImage(title1+".nd2");
roiManager("multi-measure measure_all");
sFolder = "C:/Users/loydy/Collabs_images/Phagocytosis_TP/Phg_eff/Analysis_YML/20250904_ImgMeasurements/";
saveAs("Results", sFolder+title1+"_Results.csv");

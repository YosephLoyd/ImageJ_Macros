//Author: YML
//Description: Let the user define the a parent folder to perform iterative
//thresholding on images. From these images the script defines junctional boundaries,
//the cell body, and the cell-free space boundary.
 
 //define path
dir = getDirectory("Select directory");

//define channels: actin & Zo-1
Dialog.create("Which channel is the actin img:");
Dialog.addNumber("Which channel is the actin img:", 3);
Dialog.show();
actin_ch = Dialog.getNumber();

Dialog.create("Which channel is the junction img:");
Dialog.addNumber("Which channel is the junction img:", 1);
Dialog.show();
junction_ch = Dialog.getNumber();

//define saving path for output
savePlace = dir+"//"+"ProcessedImages";
File.makeDirectory(savePlace);
//Close images before starting procedure

FindBoundaries(dir); 
  
function FindBoundaries(dir) {
   files = getFileList(dir);
   for (i=0; i<files.length; i++) {
      //If has a child folder open it and run all images in said folder. 
      //Lazy execution and will need to continue loop if found.
      if (endsWith(File.nameWithoutExtension, "/"))
         FindBoundaries(""+dir+"//"+files[i]);
      else
      	 //rename initial image for correct naming convention for cellpose
      	 run("Close All");
  		 open(dir+"//"+files[i]);
  		 rename(File.nameWithoutExtension);
         //dups
         run("Z Project...", "projection=[Max Intensity]");
         run("Duplicate...", "title=junction duplicate channels="+junction_ch);
         saveAs("Tiff", savePlace+"//junction_mip_"+File.nameWithoutExtension+".tif");
         
         selectImage("MAX_"+File.nameWithoutExtension);
         run("Duplicate...", "title=actin duplicate channels="+actin_ch);
         selectImage("actin");
         saveAs("Tiff", savePlace+"//cell_freespace_mip_"+File.nameWithoutExtension+".tif");
         saveAs("Tiff", savePlace+"//cellbody_mip_"+File.nameWithoutExtension+".tif");
         
         //work on cell body
		 selectImage("cellbody_mip_"+File.nameWithoutExtension+".tif");
		 resetMinAndMax();
         run("Enhance Contrast", "saturated=0.35");
         setOption("ScaleConversions", true);
		 run("8-bit");
		 run("Auto Threshold", "method=MinError(I) ignore_black white");
		 run("Analyze Particles...", "size=10-Infinity circularity=0-1 show=Masks clear include");
		 selectImage("Mask of "+"cellbody_mip_"+File.nameWithoutExtension+".tif");
		 run("Invert LUT");
		 saveAs("Tiff", savePlace+"//cellbody_mip_"+File.nameWithoutExtension+"_mask.tif");
		 run("Duplicate...", "title=cellbodycopy channels="+actin_ch+"-"+actin_ch);
		 
		 //work on cell free space boundary
		 selectImage("cellbody_mip_"+File.nameWithoutExtension+"_mask.tif");
		 run("Find Edges");
		 //Expand edges 5 pixels simple kernal and thresholding
		 run("Convolve...", "text1=[ 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1\n 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1\n 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1\n 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1\n 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1\n 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1\n 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1\n 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1\n 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1\n 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1\n 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1\n 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1\n 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1\n 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1\n 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1\n\n] normalize");
		 setAutoThreshold("Default no-reset");
		 //setThreshold(0, 255);
		 run("Convert to Mask");
		 run("Invert LUT");
		 saveAs("Tiff", savePlace+"//cell_freespace_mip_"+File.nameWithoutExtension+"_mask.tif");
		 
		 //work on junction
         selectImage("junction_mip_"+File.nameWithoutExtension+".tif");
         resetMinAndMax;
         run("Enhance Contrast", "saturated=0.35");
         setOption("ScaleConversions", true);
		 run("8-bit");
		 run("Auto Local Threshold", "method=Niblack radius=20 parameter_1=0.25 parameter_2=0.35 white");
		 run("Analyze Particles...", "size=10-Infinity circularity=0.00-0.125 show=Masks clear");
		 run("Invert LUT");
		 rename("junction_mip_mask1_"+File.nameWithoutExtension+".tif");
		 //image for image calculator
		 img1="junction_mip_mask1_"+File.nameWithoutExtension+".tif";
		 img2="cellbodycopy";
		 imageCalculator("Multiply create", img1, img2);
		 selectImage("Result of "+img1);
		 rename("junction_mip_mask_"+File.nameWithoutExtension+".tif");
		 saveAs("Tiff", savePlace+"//junction_mip_"+File.nameWithoutExtension+"_mask.tif");
		 
		 
		 //Close images
		 run("Close All");
		 
   }
}
//
//
//
//
//
//
dir = getDirectory("Select directory");

Dialog.create("Which channel is the actin img:");
Dialog.addNumber("Which channel is the actin img:", 1);
Dialog.show();
ch = Dialog.getNumber();

Dialog.create("What is the background intensity:");
Dialog.addNumber("Which channel is the actin img:", 112);
Dialog.show();
bg = Dialog.getNumber();

selectImage(File.name);
rename(File.nameWithoutExtension);
name= File.nameWithoutExtension;

run("Z Project...", "projection=[Max Intensity]");
selectImage("MAX_"+name);
run("Duplicate...", "duplicate channels="+ch+"-"+ch);

run("Enhance Contrast", "saturated=0.4");
run("Subtract...", "value="+bg);
setOption("ScaleConversions", true);
run("8-bit");
run("Auto Local Threshold", "method=Otsu radius=30 parameter_1=0.25 parameter_2=0 white");
run("Analyze Particles...", "size=31-Infinity circularity=0.00-0.50 show=Masks clear");

selectimage("Mask of Max_"+name);
run("Skeletonize (2D/3D)");

run("Analyze Skeleton (2D/3D)", "prune=none show");

selectWindow("Results");
save(dir+name+"General_Results.csv");
selectWindow("Branch information");
save(dir+name+"Branch_Information.csv");
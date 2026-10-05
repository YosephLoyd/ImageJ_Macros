//Author: YML, Krendel Lab
//Date: 20251107
//This script will takes the first n (number of timepoints of the movie) and
//prints a resunts table. Results table will have Intensity, Theta (from -pi to pi), 
//pixel distance from the cell centroid (microns), and the time point. User
//needs to save  results table as CSV file.

//Get image dimensions x,y,T, time is input by the user
fmax= getWidth();
dmax= getHeight();
Dialog.create("Number of time points:");
Dialog.addNumber("Number of time points:", 0);
Dialog.show();
TP=Dialog.getNumber();
qmax=TP

//For each pixel get and report pixel intensity, angle theta, distance from 
//the centroid, and time.
for (q=1;q<=qmax;q++){
	slice=q;
	setSlice(q);
	
	for (f=0;f<=fmax;f++){
		for (d=0;d<=dmax;d++){
			Stack.setChannel(1);
			Intensity=getPixel(f,d);

			if ( isNaN(Intensity) == 0 ){
				Stack.setChannel(2);
				theta=getPixel(f,d);
				Stack.setChannel(3);
				Dist=getPixel(f,d);
			
				print(Intensity,'_',theta,'_',Dist,'_',slice);
			}
		}
	}
}
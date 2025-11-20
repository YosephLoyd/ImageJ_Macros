fmax= getWidth();
dmax= getHeight();
Dialog.create("Number of time points:");
Dialog.addNumber("Number of time points:", 0);
Dialog.show();
TP=Dialog.getNumber();
qmax=TP

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
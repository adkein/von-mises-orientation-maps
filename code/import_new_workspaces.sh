#! \bin\bash

for i in `ssh cas2207@hpcsubmit.cc.columbia.edu "ls hpme/som/workspaces"`; 
do 
	if [ ! -f workspaces/$i ]; then 
		scp cas2207@hpcsubmit.cc.columbia.edu:hpme/som/workspaces/$i workspaces/; 
	fi; 
done


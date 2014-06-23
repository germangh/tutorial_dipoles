Simulating and estimating EEG sources
============

[Back to my homepage][homepage]


In this tutorial we will learn how simple intracerebral current sources can 
generate complicated patterns of EEG potentials at the scalp.
We will then see how, under certain conditions, the underlying
_EEG sources_ can be effectively localized from the scalp measurements. 
However, the tutorial also aims to illustrate how the solution to 
the _inverse EEG problem_ can be easily confounded e.g. by the presence of 
noisy background EEG activity. 

Supporting materials:

* Slides on some related [linear algebra][linalg] concepts.


[linalg]: https://speakerdeck.com/germangh/fundamentals-of-linear-algebra-for-neuroscientists


## Download and Installation

Please download the [tutorial][tutorial_dipoles] and uncompress the .zip
 file. Then simply add directory `tutorial_dipoles` and all its 
subdirectories to your MATLAB's path. 

[Download the tutorial][tutorial_dipoles]

[tutorial_dipoles]: http://github.com/germangh/tutorial_dipoles/archive/master.zip

To add a directory and all its subdirectories to MATLAB's path you can use
MATLAB's command:

	addpath(genpath('M:/mypath/tutorial_dipoles'))

where `M:/mypath/tutorial_dipoles` is the location where you uncompressed
the .zip file. In some occasions during this tutorial I will assume that
you are running MATLAB commands from the root directory of the tutorial 
(i.e. from `M:/mypath/tutorial_dipoles` in the example above). To change your
working directory do this in MATLAB:

	cd M:/mypath/tutorial_dipoles
	
where you will have to change `M:/mypath/tutorial_dipoles` for the path where
you downloaded the tutorial.


## Dependencies

The tutorial should work under MATLAB R2010a or newer. It is likely to work
also under not too much older MATLAB versions. The tutorial makes use of the
following freely available MATLAB toolboxes:

* A small subset of [Fieldtrip][fieldtrip]
* [ICP_finite][icp_finite], by D. Kroon 
* [BEMCP][fieldtrip], by C. Phillips

[fieldtrip]: http://fieldtrip.fcdonders.nl/
[icp_finite]: http://www.mathworks.nl/matlabcentral/fileexchange/24301-finite-iterative-closest-point


For convenience, all dependencies have been included in the tutorial 
.zip package so that you don't need to download them separately.


__Note:__ The tutorial uses the 3D rendering capabilities of the OpenGL 
implementation that is included with your operating system. As OpenGL 
support differ slightly between operating systems there is a small chance
that some of the figures will display differently in different operating 
systems. 


## Clearing your MATLAB search path

To prevent conflicts with other toolboxes that you may have installed on your 
system, it is best if you run the following command just before you start 
following the tutorial instructions:

````matlab
restoredefaultpath
````

The command above will set your MATLAB search path to its default factory 
setting. This change to your MATLAB search path will only be effective during
your current MATLAB session. That is, if you restart MATLAB your search path 
will be again as it was before you ran the `restoredefaultpath` command.


## Getting help

The tutorial instructions explain just a small fraction of the 
tutorial scripts' features. You can always get a more detailed help of 
individual MATLAB functions using the command `help` followed by the
name of the relevant function. For instance, the command:

````matlab
help plot
````

will display the help of MATLAB's built-in `plot` command. 

## MATLAB classes

### What are classes and objects? 

The tutorial makes use of [MATLAB's classes][matlab-classes]. Do not get get
intimidated by the term. A class is just a _user-defined data type_. MATLAB 
comes with lots of built-in data types. For instance `double` and `single`
are two types that can store numeric data:

````matlab
x = 5;
````

The variable `x` above is now an _instance_ (also called 
an _object_) of class `double`. You can find out the classes of the variables
in your MATLAB's workspace using the command `whos`. The result could be
something like this:


	>> whos
	  Name        Size              Bytes  Class       Attributes

	  myHead      1x1             2805970  head.mri              
	  x           1x1                   8  double                
	  y           1x1                   8  double              

[matlab-classes]: http://www.mathworks.nl/help/techdoc/matlab_oop/brh2rgw.html

where you can see that variable `x` is an object of class `double` and variable
`myHead` is an object of class `head.mri`. The latter is a class that we 
have defined specifically for the purposes of this tutorial. 

It is important to realize the difference between a _class_ and an _object_. 
In the example above, `x` and `y` are two different objects of the same class.

### What are class methods?

One of the great advantages of using objects with MATLAB is that it allows you
to [overload][overloading] function names. For instance, if you run the 
command:

````matlab
plot(myHead);
````	
	

[overloading]: http://en.wikipedia.org/wiki/Function_overloading

MATLAB will first check whether a specialized _method_ `plot()` has been defined
 for class `head.mri`. If such method exists then it will run that method
 instead of MATLAB's built-in function `plot()`. A `head.mri` object contains a 
head model and a `double` object contains just numbers. Indeed, plotting such
 different data types involve very different operations. Thus, it makes sense
that different versions of `plot` are called, depending on the _class_ of what
 you want to be plotted. Remember: the specialized version of `plot()` that
 takes care of plotting `mri.head` objects is called a _method_ of class 
 `mri.head`.
 
### Getting help on class' methods

Imagine that you want to get some help on method `plot()` for objects of class
`mri.head`. You could try to do this:

````matlab
help plot
````

but you will find that the help that is displayed corresponds to MATLAB's 
built-in `plot()` instead of corresponding to method `plot()` of class 
`mri.head`. Only if you read until the end of the help that is displayed you
will see a section that reads `Overloaded methods:` and that lists several
other functions that are also called `plot()`, and that will be called 
instead of the built-in, depending on the type of the input argument. 
If you already installed the tutorial scripts you should see in that list
a link reading `head.mri`. If you click that link you will get the help that
you were looking for. Alternatively, you could have just used the command:

````matlab
help head.mri.plot
````

## Note on web-browsers

This documentation uses MathML to display inlined mathematics. Unfortunately
 not all browsers support MathML natively, including Internet Explorer. In this
 case you will not be able to see the mathematical expressions correctly.
 While there is a plug-in available (MathPlayer) for adding this capability
 to Internet Explorer, in our tests this combination crashed the browser when
 viewing some of these pages. According to Wikipedia, some major web-browsers
 that currently display MathML natively include Mozilla Firefox, Opera, and
 Camino. At this point we can't do anything else than to direct you to use 
 these browsers to view these pages.	

## Public code repository

The tutorial code is also available at a [public git repository][git_repo]. Feel free 
to fork the code and enhance it in any way you want.

[git_repo]: http://github.com/germangh/tutorial_dipoles


## Credits

This tutorial has been prepared for the course [Advanced Human Neurophysiology][ahn],
 given at the [VU University Amsterdam][vu], and organized by 
[Klaus Linkenkaer-Hansen][klaus]. The author of the tutorial is 
[German Gomez-Herrero][homepage]. 

[ahn]: http://www.nbtwiki.net/doku.php?id=courses:advanced_human_neurophysiology#.TtOOWvJ7eUM
[vu]: http://www.vu.nl/en/
[klaus]: http://www.bio.vu.nl/enf/linkenkaer/


## Support 

Unfortunately, I do not have anymore time to answer personal emails requesting 
help on how to use the tutorial or to report bug. If you find a bug your best 
chance at getting me to fix it is making an [issue report at github][github-bugs].

[github-bugs]: http://github.com/germangh/tutorial_dipoles/issues

[homepage]: http://germangh.com 


## Start the tutorial

[Go to the first part of the tutorial](./head_model.md)








	








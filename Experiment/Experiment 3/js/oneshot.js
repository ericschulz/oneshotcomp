////////////////////////////////////////////////////////////////////////
//                     JS-CODE FOR GP KERNEL MCMC                     //
//                       AUTHOR: ERIC SCHULZ                          //
//                    UCL LONDON,  FEBRUARY 2016                      //
////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////
//INTIALIZE ARRAYS
////////////////////////////////////////////////////////////////////////
//Number of total trials
var kernels=['l', 'p', 's'];
var comps=['+','*']
var ntrial = 10;
var chosen=-1;
var index=0;
var kernelcollect=[];
var numbercollect=[];
var truecompcollect=[];
var compsidescollect=[];
var choicecollect=[];

////////////////////////////////////////////////////////////////////////
//CREATE HELPER FUNCTIONS
////////////////////////////////////////////////////////////////////////
//hides page hide and shows page show
function clickStart(hide, show)
{
        document.getElementById(hide).style.display ='none' ;
        document.getElementById(show).style.display ='block';
        window.scrollTo(0,0);        
}

function clickSimple(hide, show)
{
        document.getElementById(hide).style.display ='none' ;
        document.getElementById(show).style.display ='block';
}


function clickSimple2(hide, show1, show2)
{
        document.getElementById(hide).style.display ='none' ;
        document.getElementById(show1).style.display ='block';
        document.getElementById(show2).style.display ='inline';
}

function hide(hide)
{

        document.getElementById(hide).style.display ='none' ;
}


//changes inner HTML of div with ID=x to y
function change (x,y){
    document.getElementById(x).innerHTML=y;
}

function shuffle(o)
{ 
    for(var j, x, i = o.length; i; j = Math.floor(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
    return o;
}

var myboarderex=['border="0">','border="0">','border="0">','border="0">'];
var kernelnex=shuffle(kernels);
kernelnex=kernelnex.concat(kernelnex[0]);
var numbsex = [];
for (var i=0, t=10; i<t; i++) 
{
    numbsex.push(Math.round(Math.random() * 99)+1)
}

var chosenex=0;
function mymarkex(n){
    myboarderex=['border="0">','border="0">','border="0">','border="0">'];
    myboarderex[n]='border="1">';
    var comp1ex='<input type="image" src="cand/'+kernelnex[2]+compscompareex[0]+kernelnex[3]+numbsex[5]+'.png" width="200" height="200"'+ 'onclick="mymarkex(0)" '+myboarderex[0];
    change('comp1ex', comp1ex);
    var comp2ex='<input type="image" src="cand/'+kernelnex[2]+compscompareex[1]+kernelnex[3]+numbsex[6]+'.png" width="200" height="200"'+ 'onclick="mymarkex(1)" '+myboarderex[1];
    change('comp2ex', comp2ex);
    var comp3ex='<input type="image" src="cand/'+kernelnex[2]+numbsex[7]+'.png" width="200" height="200"'+ 'onclick="mymarkex(2)" '+myboarderex[2];
    change('comp3ex', comp3ex);
    var comp4ex='<input type="image" src="cand/'+kernelnex[3]+numbsex[8]+'.png" width="200" height="200"'+ 'onclick="mymarkex(3)" '+myboarderex[3];
    change('comp4ex', comp4ex);
    chosenex=n;
}





var ins1ex='<input type="image" src="imga/'+kernelnex[0]+numbsex[0]+'.png" width="200" height="200" border="0">';
var ins2ex='<input type="image" src="imgb/'+kernelnex[1]+numbsex[1]+'.png" width="200" height="200" border="0">';
var ins3ex='<input type="image" src="imgc/'+kernelnex[2]+numbsex[2]+'.png" width="200" height="200" border="0">';
var ins4ex='<input type="image" src="imgd/'+kernelnex[3]+numbsex[3]+'.png" width="200" height="200" border="0">';
change('s1ex', ins1ex);
change('s2ex', ins2ex);
change('s3ex', ins3ex);
change('s4ex', ins4ex);
var comps1ex=shuffle(comps)[0];
var compex='<input type="image" src="offspring/'+kernelnex[0]+comps1ex+kernelnex[1]+numbsex[4]+'.png" width="200" height="200" border="0">';
change('compex', compex);
var compscompareex=shuffle(comps);
var comp1ex='<input type="image" src="cand/'+kernelnex[2]+compscompareex[0]+kernelnex[3]+numbsex[5]+'.png" width="200" height="200"'+ 'onclick="mymarkex(0)" '+myboarderex[0];
change('comp1ex', comp1ex);
var comp2ex='<input type="image" src="cand/'+kernelnex[2]+compscompareex[1]+kernelnex[3]+numbsex[6]+'.png" width="200" height="200"'+ 'onclick="mymarkex(1)" '+myboarderex[1];
change('comp2ex', comp2ex);
var comp3ex='<input type="image" src="cand/'+kernelnex[2]+numbsex[7]+'.png" width="200" height="200"'+ 'onclick="mymarkex(2)" '+myboarderex[2];
change('comp3ex', comp3ex);
var comp4ex='<input type="image" src="cand/'+kernelnex[3]+numbsex[8]+'.png" width="200" height="200"'+ 'onclick="mymarkex(3)" '+myboarderex[3];
change('comp4ex', comp4ex);




////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////

var myboarder=['border="0">','border="0">','border="0">','border="0">'];


function mymark(n){
    myboarder=['border="0">','border="0">','border="0">','border="0">'];
    myboarder[n]='border="1">';
    var comp1='<input type="image" src="cand/'+testme[0]+'.png" width="200" height="200"'+ 'onclick="mymark(0)" '+myboarder[0];
    change('comp1', comp1);
    var comp2='<input type="image" src="cand/'+testme[1]+'.png" width="200" height="200"'+ 'onclick="mymark(1)" '+myboarder[1];
    change('comp2', comp2);
    var comp3='<input type="image" src="cand/'+testme[2]+'.png" width="200" height="200"'+ 'onclick="mymark(2)" '+myboarder[2];
    change('comp3', comp3);
    var comp4='<input type="image" src="cand/'+testme[3]+'.png" width="200" height="200"'+ 'onclick="mymark(3)" '+myboarder[3];
    change('comp4', comp4);
    chosen=n;
}

var kerneln=shuffle(kernels);
kerneln=kerneln.concat(kerneln[0]);
var numbs = [];

for (var i=0, t=9; i<t; i++) 
{
    numbs.push(Math.round(Math.random() * 99)+1)
}
var ins1='<input type="image" src="imga/'+kerneln[0]+numbs[0]+'.png" width="200" height="200" border="0">';
var ins2='<input type="image" src="imgb/'+kerneln[1]+numbs[1]+'.png" width="200" height="200" border="0">';
var ins3='<input type="image" src="imgc/'+kerneln[2]+numbs[2]+'.png" width="200" height="200" border="0">';
var ins4='<input type="image" src="imgd/'+kerneln[3]+numbs[3]+'.png" width="200" height="200" border="0">';
change('s1', ins1);
change('s2', ins2);
change('s3', ins3);
change('s4', ins4);
var comps1a=shuffle(comps)[0];
var comp='<input type="image" src="offspring/'+kerneln[0]+comps1a+kerneln[1]+numbs[4]+'.png" width="200" height="200" border="0">';
change('comp', comp);
var compscompare=shuffle(comps);

var testcollect=[];
var testme=[];
testme=[kerneln[2]+compscompare[0]+kerneln[3]+numbs[5], kerneln[2]+compscompare[1]+kerneln[3]+numbs[6], kerneln[2]+numbs[7], kerneln[3]+numbs[8]];
testme=shuffle(testme);
var comp1='<input type="image" src="cand/'+testme[0]+'.png" width="200" height="200"'+ 'onclick="mymark(0)" '+myboarder[0];
change('comp1', comp1);
var comp2='<input type="image" src="cand/'+testme[1]+'.png" width="200" height="200"'+ 'onclick="mymark(1)" '+myboarder[1];
change('comp2', comp2);
var comp3='<input type="image" src="cand/'+testme[2]+'.png" width="200" height="200"'+ 'onclick="mymark(2)" '+myboarder[2];
change('comp3', comp3);
var comp4='<input type="image" src="cand/'+testme[3]+'.png" width="200" height="200"'+ 'onclick="mymark(3)" '+myboarder[3];
change('comp4', comp4);

function dotrial()
{

  if (chosen>=0)
  {
   
    hide('comp');
    hide('question');   
    kernelcollect[index]=kerneln;
    testcollect[index]=testme;
    numbercollect[index]=numbs;
    truecompcollect[index]=comps1a;
    choicecollect[index]=chosen;
    chosen=-1;
    if (index <ntrial-1)
    {
         index=index+1;
         var myboarder=['border="0">','border="0">','border="0">','border="0">'];
         kerneln=shuffle(kernels);
         kerneln=kerneln.concat(kerneln[0]);
         numbs=[];
         for (var i=0, t=9; i<t; i++) 
         {
             numbs.push(Math.round(Math.random() * 99)+1)
         }
         var ins1='<input type="image" src="imga/'+kerneln[0]+numbs[0]+'.png" width="200" height="200" border="0">';
         var ins2='<input type="image" src="imgb/'+kerneln[1]+numbs[1]+'.png" width="200" height="200" border="0">';
         var ins3='<input type="image" src="imgc/'+kerneln[2]+numbs[2]+'.png" width="200" height="200" border="0">';
         var ins4='<input type="image" src="imgd/'+kerneln[3]+numbs[3]+'.png" width="200" height="200" border="0">';
         change('s1', ins1);
         change('s2', ins2);
         change('s3', ins3);
         change('s4', ins4);
         
         comps1a=shuffle(comps)[0];
         var comp='<input type="image" src="offspring/'+kerneln[0]+comps1a+kerneln[1]+numbs[4]+'.png" width="200" height="200" border="0">';
         change('comp', comp);
         compscompare=shuffle(comps);
         testme=[kerneln[2]+compscompare[0]+kerneln[3]+numbs[5], kerneln[2]+compscompare[1]+kerneln[3]+numbs[6], kerneln[2]+numbs[7], kerneln[3]+numbs[8]];
         testme=shuffle(testme);
         var comp1='<input type="image" src="cand/'+testme[0]+'.png" width="200" height="200"'+ 'onclick="mymark(0)" '+myboarder[0];
         change('comp1', comp1);
         var comp2='<input type="image" src="cand/'+testme[1]+'.png" width="200" height="200"'+ 'onclick="mymark(1)" '+myboarder[1];
         change('comp2', comp2);
         var comp3='<input type="image" src="cand/'+testme[2]+'.png" width="200" height="200"'+ 'onclick="mymark(2)" '+myboarder[2];
         change('comp3', comp3);
         var comp4='<input type="image" src="cand/'+testme[3]+'.png" width="200" height="200"'+ 'onclick="mymark(3)" '+myboarder[3];
         change('comp4', comp4);

         var remainder ="Number of trials left: "+(ntrial-index);
         change("remain1", remainder);
         
         clickStart('firstparents','next1');
         clickStart('firstoffspring','next2');
         clickStart('secondparents','next3');
         clickStart('secondoffspring','next4');
    }
    else
    {
        alert("All blocks are over. You will be directed onto the next page once you click on 'ok'.");
        clickStart('page4','page5')
    }
  }
  else
  {
    alert("Please select one of the two red patterns before continuing with the study.");
  }
}

//////////////////////////////////////////////////////////////////////////
function senddata(){
    var age=90;
    if (document.getElementById('age1').checked) {var  age = 20}
    if (document.getElementById('age2').checked) {var  age = 30}
    if (document.getElementById('age3').checked) {var  age = 40}
    if (document.getElementById('age4').checked) {var  age = 50}

    var gender=3;
    if (document.getElementById('gender1').checked) {var  gender = 1}
    if (document.getElementById('gender2').checked) {var  gender = 2}
     var oneshotfinal=1; 
      clickStart('page5','page6');

}
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
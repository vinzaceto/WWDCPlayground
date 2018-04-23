# MUchineLearning - My WWDC18 scholarship submission [Accepted]

![alt icon](https://github.com/vinzaceto/WWDCPlayground/blob/master/icon.png)


MUchineLearning is a word created from _MUsic Machine_ and _Machine Learning_
	
This playground uses machine learning to recognise gestures, that you can easily do with your hand, and it reproduces different sounds based on the different gestures. You can choose different music instruments and, in the bottom of the view, you can see what the playground is recognising every moment.
To realise this magic, I used Vision and CoreML: very powerful tools. I used Vision to get images catches by the front camera of the iPad and I passed this very heavy flow of information to CoreML that interprets it and categorises all the results sorted by percentage of probability. 

A crucial aspect of the implementation with CoreML has been defining the underlying neural network. I created my personal neural network with my iPhone camera, hundreds photos of my hands and a third part free online tool. The precision of this neural network is about 80% to recognise the right gesture that you are reproducing: obviously it is influenced by light condition and ceiling color but it works enough well.
To use the neural network in this playground, I created another project in Xcode that I used to compile the neural network model and then I putted it in to the playground.

![alt online tool](https://github.com/vinzaceto/WWDCPlayground/blob/master/Screen%20Shot%202018-03-31%20at%2009.40.21.png)



Here you can find a video demo of my Plagroundbook
https://www.youtube.com/watch?v=cvkEDOhAg4w

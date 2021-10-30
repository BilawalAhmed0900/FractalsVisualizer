# fractals_visualizer

Fractals Visualizer using [Newton's Method](https://en.wikipedia.org/wiki/Newton's_method)

# Inspiration

Inspired by this 3blue1brown's [youtube video](https://www.youtube.com/watch?v=-RdOwhmqP5s). His video has better animation than this but still this program can generate as much images as you want.

# Why Flutter

Flutter is emerging as one GUI framework to rule them all. It is easy to learn and easy to work in.
Qt could also be used but the learning curve is more steep and it's IDE (Qt Creater is plain bad).
While Android Studio is workable and is made by Jet Brains (I love their IDEs).
Similarly Dart vs Qt C++ made Dart an instant winner.

# Performance

The only main problem is that the algorithm is implemented in single-threaded mode. Each pixel of the image is calculated sequential and is independent of each other, so using ideas from CUDA and such, one can implement a highly parallel version of the algorithm but this program was implemented within 24 hours and I had other work so, I didn't bother. The feasible size to generate image of is 10000-20000 by 5000-10000 (a 2:1 image), which this program can generate within 15 minutes on (i5-9300H, Windows 10 19042.1288) using almost 300 MiB of RAM.

# Images Generated

Few images generated from this programs are
![Image 1](/fractals-images/FractalImageGenerated-1635571321113.png "4-degree-polynomial-24000x12000")
![Image 2](/fractals-images/FractalImageGenerated-1635590924955.png "5-degree-polynomial-12000x6000")

# How The Algorithm Works

Suppose you have a polynomial `P(x)` and its derivative `P'(x)`. Calculate the roots of `P(x)` and associate one color to each root.

    for x in range(rows):
      for y in range(columns):
      
        # The above 2D loop can be parallelized
      
        c = x + yi
        for i in range(steps):
          if P'(c) != 0:
            c -= P(c) / P''(c)
          else:
            break
            
        r = root(P(x)) whose distance is closest to c
        r,g,b = color of pixel associated with that root r
        image[x,y] = (r,g,b)
        
# Note

If someone owns a Mac and is seeing this. I invite you to compile for MacOS and send me the executable to this email. <blwal7057@gmail.com>

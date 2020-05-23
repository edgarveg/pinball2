class Pantallas
{
  PFont fuente1;
  int identificador;
  Pantallas (int id) 
  {
    identificador = id;
  }
void DibujodePantalla()
{
  switch (identificador)
  {
    case 1:
        fuente1 = loadFont ("Bauhaus93-48.vlw");
        textFont(fuente1);
        fill(random(107),random(221),random(123));
        textSize(101);
        text("Pinball", 200,250);
        textAlign(CENTER);
        fill(random(107),random(221),random(123));
        text("House", 200,350);
        textAlign(CENTER);
        fill(179,111,244);
        textSize(93);
        text("Pinball", 200,250);
        textAlign(CENTER);
        text("House", 200,350);
        textAlign(CENTER);
        textSize(20);
        fill(random(107),random(221),random(123));
        text("Presione enter para continuar", 200,450);
        textSize(15);
        fill(random(107),random(221),random(123));
        text("Click para ver la MAGIA", 200,470);
         textAlign(CENTER);    
     break;
     case 2:
     background(0);
     image (calv, -100, 0 , 600 ,600);
     textSize(15);
     fill(random(107),random(221),random(123));
     text("Instrcucciones", 200,100);
     text("Moviemiento de palancas con flechas", 200,120);
     text("Lanzar la pelota con clik del mouse", 200,140);
     textAlign(CENTER); 
     box2d.step();   
     pb.display();
     spring.update(mouseX,mouseY);
   for(choque b: bumpers)
  {
   b.display();
  }
  pr.display();
  pl.display(); 
  for(obstaculos o: obs)
  {
   o.display(); 
  }
  
  if(lives >= 0)
  {
    if(pb.done())
    {
     minim.stop(); 
     setup();
     --lives; 
    }
  }
  else
  {
   lives = 1;
   minim.stop();
   setup();
  }
  for(Pair p: pairs) {
    p.display();
  }
  rp = true;
  lp = true;
} 
}
}

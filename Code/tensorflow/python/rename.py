import os 
 
def rename(dir): 
  listOfFiles = os.listdir(dir) 
  print(listOfFiles) 
  for i in range(len(listOfFiles)): 
      os.rename( 
          os.path.join(dir, listOfFiles[i]), 
          os.path.join(dir, "image"+str(i).zfill(4)+".png") 
          ) 
 
if __name__ == '__main__': 
  rename('/home/phil/Repos/cnn-gesture-recognition/db/mozaic/')
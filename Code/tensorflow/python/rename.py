import os 
 
def rename(dir): 
  listOfFiles = os.listdir(dir) 
  print(listOfFiles) 
  for i in range(len(listOfFiles)): 
      os.rename( 
          os.path.join(dir, listOfFiles[i]), 
          os.path.join(dir, "pixel"+str(i).zfill(4)+".txt")
          ) 
 
if __name__ == '__main__': 
  rename('/home/phil/Repos/cnn-gesture-recognition/db/pixels/')
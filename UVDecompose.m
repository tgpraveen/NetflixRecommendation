
function UVDecompose(fileName)
  global udim1 = 2649429;
  global vdim2 = 17770;
  initializeM(fileName);
  uvdMain();
end

function uvdMain()
  %{For example we could add to each element a
  #normally distributed value with mean 0 and some chosen standard deviation.
  #Or we could add a value uniformly chosen from the range −c to +c for some c.
  #We are varying c from -3 to +3.%}

  c=-4;
  prevrmse=0;
  a=3;
  d=1;
  global udim1;
  udim2=d;
  vdim1=d;
  global vdim2;
  global mmatrix;
  global validUsers;

  while true
    if c<4
      c++;
    else break;
    end
    matrixval=sqrt(a/d)+c;

    umatrix=ones(udim1, udim2)*matrixval;
    vmatrix=ones(vdim1,vdim2)*matrixval;

    pmatrix=umatrix*vmatrix;

    for i = 1:size(pmatrix)(1)
      if validusers(1,i)
        for j=1:size(pmatrix)(2)
          pmatrix(i,j)=pmatrix(i,j)-mmatrix(i,j);
        end
      end
    end

    rmse=0;

    for i = 1:size(pmatrix)(1)
      if (validusers(1,i) != 0)
        for j=1:size(pmatrix)(2)
          #pmatrix(i,j)=pmatrix(i,j)-mmatrix(i,j);
          rmse = rmse + (pmatrix(i,j)*pmatrix(i,j));
        end
      end
    end

    if(rmse < prev_rmse)
      diff_prev_rmse_current_rmse=abs(prev_rmse-rmse);
      threshold = 0.00001;

      if (diff_prev_rmse_current_rmse<threshold) 
        break;
      end
      prev_rmse=rmse
    end
  end

end

function initializeM(fileName)
  global mmatrix;
  global udim1;
  global vdim2;
  mmatrix = sparse(udim1, vdim2);
  global validUsers;
  validUsers = zeros(1, udim1);

  fid = fopen(fileName);
  tline = fgets(fid);
  while ischar(tline)
    tline
    digitStart = digitEnd = 1;

    while(tline(digitEnd) != '[')
      digitEnd=digitEnd+1;
    end
    userId=str2num(tline(digitStart:digitEnd-1));
    userId
    validUsers(1, userId) = 1;
    mmatrix(userId, :) = -10000;

    digitEnd=digitEnd+2;
    while(tline(digitEnd) != ']')
      digitStart= digitEnd;
      while(tline(digitEnd) != ':')
        digitEnd = digitEnd+1;
      end
      movieId = str2num(tline(digitStart:digitEnd-1));
      movieId
      digitEnd = digitEnd+1;
      digitStart= digitEnd;
      while(tline(digitEnd) != ',' && tline(digitEnd) != ']')
        digitEnd = digitEnd+1;
      end
      rating = str2num(tline(digitStart:digitEnd-2));
      rating
      mmatrix(userId, movieId) = rating;
      if(tline(digitEnd) == ',')
        digitEnd=digitEnd+2;
      end
    end
    tline = fgets(fid);
  end
end

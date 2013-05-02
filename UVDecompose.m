
function UVDecompose(fileName)
  global udim1;
  udim1 = 480189;
  %udim1 = 4801;
  global vdim2 ;
  vdim2 = 17770;
  initializeM(fileName);
  uvdMain();
end

function initializeM(fileName)
  global mmatrix;
  global udim1;
  global vdim2;
  global nullRating;
  %Indicates the movie is not rated
  nullRating = -10000;
  mmatrix = ones(udim1, vdim2)*(nullRating);
  global validUsers;
  validUsers = zeros(1, udim1);

  fid = fopen(fileName);
  tline = fgets(fid);
  userNum = 1;
  while ischar(tline)
    %tline
    pos = 1;

    [A, count, errmsg, nextIndex] = sscanf(tline(pos:length(tline)),'%d');
    userId = A;
    pos = pos + nextIndex;
    validUsers(1, userNum) = userId;

    [movies, count, errmsg, nextIndex] = sscanf(tline(pos:length(tline)),'%d');
    if(count ~= 0)
      pos = pos+nextIndex;
      [ratings, count, errmsg, nextIndex] = sscanf(tline(pos:length(tline)),'%f');
      sz = size(movies);
      for i = 1:sz(1)
        mmatrix(userNum, movies(i,1)) = ratings(i,1);
      end
      pos = pos+nextIndex;
    end

    tline = fgets(fid);
    userNum = userNum +1;
    userNum
  end
end

function uvdMain()
  %{For example we could add to each element a
  %normally distributed value with mean 0 and some chosen standard deviation.
  %Or we could add a value uniformly chosen from the range −c to +c for some c.
  %We are varying c from -3 to +3.%}

  c=-4;
  prev_rmse=-10;
  a=3;
  d=5;
  global udim1;
  udim2=d;
  vdim1=d;
  global vdim2;
  global mmatrix;
  global validUsers;
  global nullRating;
  global bestU;
  global bestV;

  umatrixturn=true;

  while true
    if c<4
      c = c+1;
      breakthree=false;
    else
      break;
    end
    matrixval=sqrt(a/d)+c;

    umatrix=ones(udim1, udim2)*matrixval;
    vmatrix=ones(vdim1,vdim2)*matrixval;
    counter=1;


    while breakthree==false
      r = 1;
      s = 1;
      r_v = 1;
      s_v = 1;

      breakU=false;
      breakV=false;
      while !(breakU==true && breakV == true)
        if (umatrixturn==true) && (breakU==false)
          disp('umatrixturn')
          r
          s
          umatrix(r,s)=0;
          numerator=0;
          numeratorsummationterm=0;
          denominator=0;
          for j = 1:vdim2
            if mmatrix(r,j) > (nullRating+1)
              for k=1:d
                if k~=s
                  numeratorsummationterm = numeratorsummationterm+(umatrix(r,k)*vmatrix(k,j));
                end
              end
              numerator = numerator + ( vmatrix(s,j) * (mmatrix(r,j) - numeratorsummationterm));
              denominator=denominator+(vmatrix(s,j)*vmatrix(s,j));
            end
          end
          numerator
          denominator

          umatrix(r,s)=numerator/denominator;
          if s~=d
            s=s+1;
          else 
            if r~=udim1
              r=r+1;
              s=1;
            else 
              breakU=true
            end
          end

          umatrixturn=false
        end
        umatrixturn
        breakV

        if (umatrixturn==false) && (breakV==false)
          disp('vmatrixturn')
          r_v
          s_v
          vmatrix(r_v,s_v)=0;
          numerator_v=0;
          numeratorsummationterm_v=0;
          denominator_v=0;
          for i = 1:udim1
            if mmatrix(i, s_v) > (nullRating+1)
              for k=1:d
                if k~=r_v
                  numeratorsummationterm_v=numeratorsummationterm_v+(umatrix(i,k)*vmatrix(k,s_v));
                end
              end
              numerator_v = numerator_v + (umatrix(i,r_v)*(mmatrix(i,s_v)-numeratorsummationterm_v));
              denominator_v = denominator_v+(umatrix(i,r_v)*umatrix(i,r_v));
            end
          end

          numerator_v
          denominator_v
          vmatrix(r_v,s_v)=numerator_v/denominator_v;

          if r_v~=d
            r_v=r_v+1;
          else
            if s_v~=vdim2
              s_v=s_v+1;
              r_v=1;
            else 
              breakV=true
            end
          end
        end			

        umatrixturn=true;
      end
      %{RMSE CODE%}
      pmatrix=umatrix*vmatrix;

      sz = size(pmatrix);
      for i = 1:sz(1)
        for j = 1:sz(2)
          if mmatrix(i,j) > (nullRating+1)
            pmatrix(i,j) = pmatrix(i,j)-mmatrix(i,j);
          end
        end
      end

      rmse=0;

      for i = 1:sz(1)
        for j = 1:sz(2)
          %pmatrix(i,j)=pmatrix(i,j)-mmatrix(i,j);
          if mmatrix(i,j)> (nullRating+1)
            rmse = rmse + (pmatrix(i,j)*pmatrix(i,j));
          end
        end
      end
      S=sprintf('RMSE is: %f',rmse);
      disp(S)
      if(rmse <= prev_rmse)
        diff_prev_rmse_current_rmse=(prev_rmse-rmse);
        threshold = 0.00001;

        if (diff_prev_rmse_current_rmse<threshold) 
          breakthree=true
        end
        prev_rmse=rmse;
        bestU=umatrix;
        bestV=vmatrix;
      end
    end
   % breakthree=true%
  end
  disp(bestU)
  disp(bestV)
end

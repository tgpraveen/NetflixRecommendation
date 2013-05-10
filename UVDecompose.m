
function UVDecompose(fileName)
  global udim1;
  global vdim2 ;
  udim1 = 17770;
  vdim2 = 480189;
  datestr(now, 'dd-mm-yyyy HH:MM:SS FFF')
  initializeM(fileName);
  uvdMain();
  datestr(now, 'dd-mm-yyyy HH:MM:SS FFF')
end

function initializeM(fileName)
  global mmatrix;
  global udim1;
  global vdim2;
  %Indicates the movie is not rated
  mmatrix = sparse(udim1, vdim2);
  global validUsers;
  validUsers = zeros(1, udim1);

  fid = fopen(fileName);
  tline = fgets(fid);
  userNum = 1;
  bulkSize = 1000;
  bulk_rating_update = zeros(udim1, bulkSize);
  while ischar(tline)
    %tline
    pos = 1;

    [A, count, errmsg, nextIndex] = sscanf(tline(pos:length(tline)),'%d');
    userId = A;
    pos = pos + nextIndex;
    validUsers(1, userNum) = userId;

    [movies, count, errmsg, nextIndex] = sscanf(tline(pos:length(tline)),'%d');
    pos = pos+nextIndex;
    [ratings, count, errmsg, nextIndex] = sscanf(tline(pos:length(tline)),'%f');
    sz = size(movies);

    for i = 1:sz(1)
      bulkIndex = mod(userNum, bulkSize);
      if(bulkIndex == 0)
        bulkIndex = bulkSize;
      end
      if (ratings(i,1) == 0) 
        %This is done to distinguish between unrated and normalized ratings with value 0.
        %Unrated movies will have value 0 in sparse matrix
        bulk_rating_update(movies(i,1), bulkIndex) = 0.0001;
      else
        bulk_rating_update(movies(i,1), bulkIndex) = ratings(i,1);
      end
    end

    if(userNum == vdim2 && mod(userNum, bulkSize) ~= 0)
      %We have scanned the entire list. So we have to flush out bulk entries into sparse matrix mmatrix
      startUserNum = userNum - mod(userNum, bulkSize) + 1;
      mmatrix(:, startUserNum:(userNum) ) = bulk_rating_update(:, 1:mod(userNum, bulkSize));  %Batch update the sparse matrix for users within user BulkSize window
      disp('Final Bulk update')
      userNum

    else
      if(mod(userNum, bulkSize) == 0)
        mmatrix(:, (userNum-bulkSize+1):(userNum) ) = bulk_rating_update;     %Batch update the sparse matrix for users within user BulkSize window
        bulk_rating_update = zeros(udim1, bulkSize);
        %userNum

      end
    end

    pos = pos+nextIndex;

    tline = fgets(fid);
    userNum = userNum +1;

  end
end

function uvdMain()
  %{For example we could add to each element a
  %normally distributed value with mean 0 and some chosen standard deviation.
  %Or we could add a value uniformly chosen from the range −c to +c for some c.
  %We are varying c from -3 to +3.%}

  c=-3;
  prev_rmse=-10;
  a=3;
  d=5;
  global udim1;
  udim2=d;
  vdim1=d;
  global vdim2;
  global mmatrix;
  global validUsers;
  global bestU;
  global bestV;

  umatrixturn=true;

  while true
    if c<3
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
      while ~(breakU==true && breakV == true)
        if (umatrixturn==true) && (breakU==false)
          %disp('umatrixturn')
          %r
          %s
          umatrix(r,s)=0;
          numerator=0;
          numeratorsummationterm=0;
          denominator=0;
          for j = 1:vdim2
            if mmatrix(r,j) ~= 0
              for k=1:d
                if k~=s
                  numeratorsummationterm = numeratorsummationterm+(umatrix(r,k)*vmatrix(k,j));
                end
              end
              numerator = numerator + ( vmatrix(s,j) * (mmatrix(r,j) - numeratorsummationterm));
              denominator=denominator+(vmatrix(s,j)*vmatrix(s,j));
            end
          end
          %numerator
          %denominator

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
        %umatrixturn
        %breakV

        if (umatrixturn==false) && (breakV==false)
          %disp('vmatrixturn')
          %r_v
          %s_v
          vmatrix(r_v,s_v)=0;
          numerator_v=0;
          numeratorsummationterm_v=0;
          denominator_v=0;
          for i = 1:udim1
            if mmatrix(i, s_v) ~= 0
              for k=1:d
                if k~=r_v
                  numeratorsummationterm_v=numeratorsummationterm_v+(umatrix(i,k)*vmatrix(k,s_v));
                end
              end
              numerator_v = numerator_v + (umatrix(i,r_v)*(mmatrix(i,s_v)-numeratorsummationterm_v));
              denominator_v = denominator_v+(umatrix(i,r_v)*umatrix(i,r_v));
            end
          end

          %numerator_v
          %denominator_v
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
      pmatrix = sparse(udim1, vdim2);

      sz = size(pmatrix);
      rmse=0;
      for i = 1:sz(1)
        bulk_p_update = zeros(1, vdim2);
        for j = 1:sz(2)
          if mmatrix(i,j) ~= 0
            pmatrix_entry = dot(umatrix(i),vmatrix(j));
            err = pmatrix_entry-mmatrix(i,j);
            rmse = rmse + (err*err);
          end
        end
      end

      S=sprintf('RMSE is: %f',rmse);
      datestr(now, 'dd-mm-yyyy HH:MM:SS FFF')
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
      else
        disp('RMSE does not decrease');
      end
    end
    % breakthree=true%
  end
  %disp(bestU)
  %disp(bestV)
end

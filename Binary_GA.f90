!     Binary GA
!     This Fortran 90 program written by Chin-Wei Wang
!     This program used the genetic algorithm to optimize the f(x,y)
!     Which based on the basic binary gnentic generating
      program Binary_GA
        implicit none
        integer :: Nbit,Npop,Npop_min,Npop_max,Nf_max,Nf,N_gen,Run_max,Run_time,i,Iter,Success
        real,dimension(2) :: subj_X,subj_Y,P_cross
        real,dimension(:),allocatable :: F,X,Y,BestX,BestY,Elitism_X,Elitism_Y,X_best,Y_best,F_best,F_avg
        integer,dimension(:,:),allocatable :: GeneX,GeneY,Parent_X,Parent_Y,Child_X,Child_Y
        real :: fref,P_mutate,P_creep,rand,F_sum,Success_rate

        !open(2,file='Binary_GA.dat',form='formatted')
!     **************** Input_Data *******************
        Nbit     = 30
        Npop_min = 10
        Npop_max = 50
        Run_max  = 20           ! Run maximum time
        Nf_max   = 20000        ! Maximum Calculate times
        fref     = 0.           ! Estimated minimum fref

        subj_X   = (/0.,10./)   ! (0 ≤ X ≤ 10)
        subj_Y   = (/1.,11./)   ! (1 ≤ Y ≤ 11)
        P_cross  = (/0.9,1./)   ! (0.5 ≤ P_cross ≤ 1)
        P_mutate = 0.05         ! (P_mutate ≤ 0.1)
        P_creep  = 1.0
!     ***********************************************
        allocate(BestX(Nbit+1),BestY(Nbit+1),Elitism_X(Nbit+1),Elitism_Y(Nbit+1))
        allocate(X_best(1),Y_best(1),F_best(1))
        allocate(Parent_X(Nbit,2),Child_X(Nbit,2),Parent_Y(Nbit,2),Child_Y(Nbit,2))
        Elitism_X(1)=fref    ! Initialize Elitism
        Elitism_Y(1)=fref    ! Initialize Elitism
        Success=0.           ! Initialize Success times
        Nf=0                 ! Initialize Number of Calculate
        N_gen=0
        do Run_time=1,Run_max
          Nf=0
          call random_number(rand)
          Npop=INT(rand*(Npop_max-Npop_min))+Npop_min
          allocate(GeneX(Nbit,Npop),GeneY(Nbit,Npop))
          allocate(X(Npop),Y(Npop),F(Npop),F_avg(Nf_max))
          call Initialize ( Nbit, Npop, GeneX )
          call Initialize ( Nbit, Npop, GeneY )
          call Decode(Nbit, Npop, GeneX, subj_X, X)
          call Decode(Nbit, Npop, GeneY, subj_Y, Y)
!          fref=0.             ! Reset fref during loop
          call Function_Evaluation (Nbit, Npop, fref, X, Y, F)
          BestX(1)=fref       ! Initialize Best
          BestY(1)=fref       ! Initialize Best
          call Get_Best (Nbit, Npop, F, fref, GeneX, GeneY, BestX, BestY)
          F_sum=0.

          do Iter=1,Nf_max
            if (Iter*Npop .ge. Nf_max) then
              !write(*,*)'Ckeck Convergence Success at Nfmax'
              exit            ! Check the Nf_max
            endif
            
            call RW_Selection (Nbit, Npop, F, fref, GeneX, Parent_X )
            call Single_Point_Crossover (Nbit, P_cross, Parent_X, Child_X )
            call Jump_Mutation (Nbit,2, P_mutate ,Child_X )
            call Decode(Nbit, 2, Child_X, subj_X, X)

            call RW_Selection (Nbit, Npop, F, fref, GeneY, Parent_Y )
            call Single_Point_Crossover (Nbit, P_cross, Parent_Y, Child_Y )
            call Jump_Mutation (Nbit,2, P_mutate ,Child_Y )
            call Decode(Nbit, 2, Child_Y, subj_Y, Y)

            call Function_Evaluation (Nbit, 2, fref, X, Y, F)
            call Get_Best (Nbit, 2, F, fref, Child_X, Child_Y, BestX, BestY)

            F_sum=F_sum+sum(F)
            F_avg(Iter)=F_sum/(Iter*Npop)

!            write(*,*)'Ngen=',Iter,'F_best=',BestX(1)+fref,'F_avg=',F_avg(Iter)
            
!            write(2,*) Iter,BestX(1)+fref,F_avg(Iter)
            Nf=Nf+1

          enddo

          call Decode(Nbit, 1, INT(BestX(2:Nbit+1)), subj_X, X)
          call Decode(Nbit, 1, INT(BestY(2:Nbit+1)), subj_Y, Y)
          call Function_Evaluation (Nbit, 1, fref, X, Y, F)
          call Elitism (Nbit, BestX, BestY, Elitism_X, Elitism_Y)
          call Creeping (Nbit,P_creep,subj_X,subj_Y,fref,Elitism_X,Elitism_Y)

          N_gen=N_gen+Nf*Npop
          write(6,*)'Npop=',Npop,'favg=',F_sum/(Iter*Npop),'f(x,y)=',F(1),'X=',X(1),'Y=',Y(1)
!          write(2,*)'Npop=',Npop,'f(x,y)=',F(1),'X=',X(1),'Y=',Y(1)

          deallocate(GeneX,GeneY,X,Y,F,F_avg)
          if (BestX(1)+fref .ge. 22.) then
            !write(6,*)'Ckeck Convergence Success at F = 22'
            Success=Success+1
            !exit            ! Check the Nf_max
          endif


        enddo

        call Decode(Nbit, 1, INT(Elitism_X(2:Nbit+1)), subj_X, X_best)
        call Decode(Nbit, 1, INT(Elitism_Y(2:Nbit+1)), subj_Y, Y_best)
        call Function_Evaluation (Nbit, 1, fref, X_best, Y_best, F_best)

        Success_rate=Success*100./Run_time

        write(6,*)'----------------  Result  ----------------------'
        write(6,*)'Number of generation =',N_gen
        write(6,*)'Run time   =',Run_time
        write(6,*)'Best f(x,y) =',F_best,'X=',X_best,'Y=',Y_best
!        write(2,*)'Best f(x,y) =',F_best,'X=',X_best,'Y=',Y_best
        write(6,*)'------------------------------------------------'
        write(6,*)'Success_rate=',Success_rate,'Success time=',Success
!        write(6,*)'X_Gene  =',INT(Elitism_X(2:Nbit+1)),'Y_Gene  =',INT(Elitism_Y(2:Nbit+1))
!        write(2,*)'X_Gene  =',INT(Elitism_X(2:Nbit+1)),'Y_Gene  =',INT(Elitism_Y(2:Nbit+1))

      end program Binary_GA

!     **************** Initialize ******************
      subroutine Initialize ( Nbit, Npop, Gene )
        implicit none
        integer,intent(in) :: Nbit,Npop
        integer,intent(out),dimension(Nbit,Npop) :: Gene
        integer :: i,j
        real :: rand

        do j=1, Npop
          do i=1, Nbit
          call random_number(rand)
          if (rand .lt. 0.5) then
            Gene(i,j)=0
          else
            Gene(i,j)=1
          end if
          enddo
        enddo
        return

      end subroutine Initialize

!     ******************* Decode *******************
      subroutine Decode(Nbit, Npop, Gene, subj, X)
        implicit none
        integer,intent(in) :: Nbit,Npop
        integer,intent(in),dimension(Nbit,Npop) :: Gene
        real,intent(in),dimension(2) :: subj
        real,intent(out),dimension(Npop) :: X
        real,dimension(Npop) :: G
        integer :: i,k

        do k=1,Npop
          G(k)=0.
          X(k)=0.
          do i=1,Nbit
            G(k)=G(k)+Gene(i,k)*(1.0/(2.0**(i)))
          enddo
          X(k)=G(k)*(subj(2)-subj(1))+subj(1) ! Mapping to the subject interval
        enddo
        return

      end subroutine Decode

!     ************* Function_Evaluation ************
      subroutine Function_Evaluation (Nbit, Npop, fref, X, Y, F)
        implicit none
        integer,intent(in) :: Nbit,Npop
        real,intent(in),dimension(Npop) :: X,Y
        real,intent(in) :: fref
        real,intent(out),dimension(Npop) :: F
        integer :: i

        do i=1,Npop
          F(i)=0.
          F(i)=1. + X(i)*sin(4*X(i))+1.1*Y(i)* sin(2*Y(i))  ! Given f(x,y) => Fobj
          if (F(i) .lt. fref) then
!            fref=F(i)
          end if
        enddo
        return

      end subroutine Function_Evaluation

!     ******************** Get_Best *****************
      subroutine Get_Best (Nbit, Npop, F, fref, GeneX, GeneY, BestX, BestY)
        implicit none
        integer,intent(in) :: Nbit,Npop
        real,intent(in),dimension(Npop) :: F
        real,intent(in) :: fref
        integer,intent(in),dimension(Nbit,Npop) :: GeneX,GeneY
        real,intent(inout),dimension(Nbit+1) :: BestX,BestY
        integer :: i
        
        do i=1,Npop
          if ((F(i)-fref) .gt. BestX(1) ) then                ! Fitness
            BestX=(/F(i)-fref,real(GeneX(1:Nbit,i))/)         ! Save the BestX
            BestY=(/F(i)-fref,real(GeneY(1:Nbit,i))/)         ! Save the BestY
          end if
        enddo
        return

      end subroutine Get_Best

!     ************** RW Selection ******************
      subroutine RW_Selection (Nbit, Npop, F, fref, Gene, Parent)
        implicit none
        integer,intent(in) :: Nbit,Npop
        real,intent(in),dimension(Npop) :: F
        real,intent(in) :: fref
        integer,intent(in),dimension(Nbit,Npop) :: Gene
        integer,intent(out),dimension(2,Nbit) :: Parent
        real,dimension(Npop) :: Prob
        real,dimension(Npop+1) :: Boundary
        real :: F_sum,fmin,rand
        integer :: i,j,Selected
        
       
        fmin=minval(F)
        F_sum=sum(F)-fmin

        Boundary(1)=0.
 
        do i=1,Npop
          Prob(i)=(F(i)-fmin)/F_sum            ! Probability
          Boundary(i+1)=Boundary(i)+Prob(i)    ! Boundary of each Proportional Section
        enddo

        do j=1,2
          call random_number(rand)
          do i=1,Npop
            if (rand .gt. Boundary(i) .and. rand .lt. Boundary(i+1)) then
                 Selected=i
                 Parent(1:Nbit,j)=Gene(1:Nbit,Selected)
                 exit
            endif
          enddo
        enddo
        return

      end subroutine RW_Selection

!     ********** Single Point Crossover ************
      subroutine Single_Point_Crossover (Nbit, P_cross, Parent, Child)
        implicit none
        integer,intent(in) :: Nbit
        real,intent(in),dimension(2) :: P_cross
        integer,intent(in),dimension(Nbit,2) :: Parent
        integer,intent(out),dimension(Nbit,2) :: Child
        real :: rand
        integer :: randC

        call random_number(rand)
        if (rand .lt. P_cross(1)) then
          call random_number(rand)
          randC=INT(rand*Nbit)+1
!         Successful Crossover
          Child(1:Nbit,1)=(/Parent(1:randC,1),Parent(randC+1:Nbit,2)/)
          Child(1:Nbit,2)=(/Parent(1:randC,2),Parent(randC+1:Nbit,1)/)
        else
          Child = Parent
        end if

      return
      end subroutine Single_Point_Crossover

!     *************** Jump Mutation ****************
      subroutine Jump_Mutation (Nbit, Npop, P_mutate ,Gene)
        implicit none
        integer,intent(in) :: Nbit,Npop
        real,intent(in) :: P_mutate
        integer,intent(inout),dimension(Nbit,Npop) :: Gene
        real :: rand
        integer :: i,j

        do j=1,Npop
          do i=1,Nbit
            call random_number(rand)
            if (rand .le. P_mutate) then
              select case (Gene(i,j))        ! Mutate Gene 0 <=> 1
              case (0)
                Gene(i,j)=1
              case (1)
                Gene(i,j)=0
              case default
                write(6,*)'Gene Error !'
              end select
            end if
          enddo
        enddo

      return
      end subroutine Jump_Mutation

!     ****************** Elitism *******************
      subroutine Elitism (Nbit, BestX, BestY, Elitism_X, Elitism_Y)
        implicit none
        integer,intent(in) :: Nbit
        real,intent(in),dimension(Nbit+1) :: BestX,BestY
        real,intent(inout),dimension(Nbit+1) :: Elitism_X,Elitism_Y
        integer :: i

        if ( BestX(1) .gt. Elitism_X(1) ) then   ! Fitness
          Elitism_X=BestX                        ! Save the Elitism_X
          Elitism_Y=BestY                        ! Save the Elitism_Y
        end if

      return
      end subroutine Elitism
!     ***************** Creeping *******************
      subroutine Creeping (Nbit,P_creep,subj_X,subj_Y,fref,Elitism_X,Elitism_Y)
        implicit none
        integer,intent(in) :: Nbit
        real,intent(in) :: P_creep,fref
        real,intent(in),dimension(2) :: subj_X,subj_Y
        real,intent(inout),dimension(Nbit+1) :: Elitism_X,Elitism_Y
        real,dimension(Nbit+1) :: BestX,BestY
        real,dimension(1) :: X,Y,F
        real :: rand
        integer :: randC

        BestX=Elitism_X
        BestY=Elitism_Y
        
        call random_number(rand)
        if (rand .lt. P_creep) then
          call random_number(rand)
          randC=INT(rand*Nbit)+2                ! Due to Elitism(fitness,[Gene])
          Elitism_X=(/Elitism_X(randC+1:Nbit+1),Elitism_X(2:randC)/)
        endif

        call random_number(rand)
        if (rand .lt. P_creep) then
          call random_number(rand)
          randC=INT(rand*Nbit)+2                ! Due to Elitism(fitness,[Gene])
          Elitism_Y=(/Elitism_Y(randC+1:Nbit+1),Elitism_Y(2:randC)/)
        endif

        call Decode(Nbit, 1, INT(Elitism_X(2:Nbit+1)), subj_X, X)
        call Decode(Nbit, 1, INT(Elitism_Y(2:Nbit+1)), subj_Y, Y)
        call Function_Evaluation (Nbit, 1, fref, X, Y, F)
        Elitism_X(1)=F(1)-fref
        Elitism_Y(1)=F(1)-fref
        if (BestX(1) .le. Elitism_X(1) ) then
          write(6,*)'Creeping Success'
        end if
        call Elitism (Nbit, BestX, BestY, Elitism_X, Elitism_Y)

      end subroutine Creeping

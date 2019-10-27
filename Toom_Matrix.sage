def Toom_Matrix (K,q) :
    # input is the size of the toom
    assert (K == int(K) and K >= 3)
    # output is a 2-dimensional array, the Toom interpolation matrix mod q
    matrix_eval = matrix(QQ, 2*K-1, 2*K-1)
    points_eval = [0 for i in range(2*K-1)]
    points_eval[1] = infinity
    points_eval[2] = 1
    points_eval[3] = -1
    for i in range(1,int((K-1)/2)) :
        points_eval[4*i] = 2^i
        points_eval[4*i+1] = - 2^i
        points_eval[4*i+2] = 2^(-i)
        points_eval[4*i+3] = - 2^(-i)
    if (K % 2 == 0) :
        points_eval[2*K-4] = 2^(K/2)
        points_eval[2*K-3] = - 2^(K/2)
        points_eval[2*K-2] = 2^(-K/2)
    else :
        points_eval[2*K-2] = 2^((K-1)/2)
    matrix_eval[0,0] = 1
    matrix_eval[1,2*K-2] = 1
    for i in range(2,2*K-1) :
        if (points_eval[i] == int(points_eval[i])) :
            for j in range(2*K-1) :
                matrix_eval[i,j] = points_eval[i]^j
        else :
            for j in range(2*K-1) :
                matrix_eval[i,j] = points_eval[i]^(j-(K-1))
    #return(matrix_eval)
    matrix_interpol = matrix_eval.inverse()
    for i in range(2*K-1) :
        for j in range(2*K-1) :
            matrix_interpol[i,j] = cmod(matrix_interpol[i,j],q)
    return(str(sage_input(matrix_eval.delete_columns(range(K,2*K-1))))[11:-1],
           str(sage_input(matrix_interpol))[11:-1])

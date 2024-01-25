# CGFTSVM-ID
Class probability and generalized bell fuzzy twin SVM for imbalanced data (CGFTSVM-ID)
This code corresponds to the paper:  Anuradha Kumari, M. Tanveer∗ Senior Member, IEEE,, C.T. Lin, Fellow, IEEE. "Class probability and generalized bell fuzzy twin SVM for imbalanced data".

If you are using our code, please give proper citation to the above given paper.

If there is any issue/bug in the code please write to phd2101141007@iiti.ac.in or anuradha878919@gmail.com


%%%%%%%%%%%%Description of files
1. Main file: This is the main file of CGFTSVM-ID. To utilize this code, you simply need to import the data and execute this script. Within the script, you will be required to provide values for various parameters.
To replicate the results achieved with CGFTSVM-ID, please adhere to the same instructions outlined in the paper "Class probability and generalized bell fuzzy twin SVM for imbalanced data". 

2. CGFTSVM_ID_func: This file contains the function to solve the optimization problem using SOR and calculates the AUC value.

3. qpSOR_CGFTSVM_ID: This function solves the optimization problem using SOR.

4. kernelfun_CGFTSVM_ID: This function corresponds to the kernel function mapping of data points. 

5. gbell_mem_func: It assigns membership value to the data points using the proposed CPGB membership function.


NOTE: The dataset imported here is KEEL data set "bupa-or-liver-disorders". And the parameters passed are optimal parameters corresponding to the dataset. 

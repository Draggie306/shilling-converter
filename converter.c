#include <stdio.h>
#include <math.h>

int main(void) {
    char choice;
    int pounds, shillings, pence;
    int totalOldPence, resultPounds, resultShillings, resultPence, oldPenceTotal, metricPounds, metricPence;

    double metricAmount, decimalPounds;

    printf("Welcome to the shilling converter\n");
    printf("Would you like to:\n");
    printf("1) Convert from old English currency to the metric equivalent\n\n");
    printf("--or--\n\n");
    printf("2) Convert the present-day metric system to the pre-1971 system?\n");
    printf("\nEnter your choice: ");
    choice = getchar();

    /*
    perform metric to shilling conversion for choice 2
    */
    if (choice == '2') {
        printf("\nConverting from metric to shilling confirmed.\n");
        printf("Enter the number of pounds: ");
        scanf("%d", &pounds);
        printf("Enter the number of pence: ");
        scanf("%d", &pence);

        /* convert the pence value and break into shillings and remainder pence. */
        decimalPounds = pounds + pence / 100.0;
        
        totalOldPence = (int)(decimalPounds * 240);

        resultPounds = totalOldPence / 240;
        resultShillings = (totalOldPence % 240) / 12;
        resultPence = totalOldPence % 12;

        printf("\nResult: £%d, %d shillings, %d pence\n", resultPounds, resultShillings, resultPence);
    } else {
        /* any other case: perform shilling to metric conversion. */
        printf("\nConverting from shilling to metric confirmed.\n");
        printf("Enter the number of pounds: ");
        scanf("%d", &pounds);
        printf("Enter the number of shillings: ");
        scanf("%d", &shillings);
        printf("Enter the number of pence: ");
        scanf("%d", &pence);

        /* in ConvertToecimal: total pence = (pounds * 240) + (shillings * 12) + pence. */
        oldPenceTotal = pounds * 240 + shillings * 12 + pence;
        
        /* convert to metric pounds/pence */
        metricAmount = oldPenceTotal / 240.0;

        /* separate metric pounds & pence */
        metricPounds = (int)metricAmount;
        metricPence = (int)round((metricAmount - metricPounds) * 100);
        printf("\nResult: £%d and %d pence (metric format)\n", metricPounds, metricPence);
    }
    return 0;
}
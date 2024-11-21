//+------------------------------------------------------------------+
//| EMA_Calculations.mqh                                             |
//+------------------------------------------------------------------+
//| Contains functions for EMA calculations                          |
//+------------------------------------------------------------------+

bool CalculateEMA(int period, double &emaArray[])
{
   int rates_total = Bars(_Symbol, PERIOD_CURRENT);
   if (rates_total < period)
      return false; // Not enough data

   // Resize the EMA array
   ArrayResize(emaArray, rates_total);

   // Get close prices
   double closePrices[];
   ArraySetAsSeries(closePrices, true);
   if (CopyClose(_Symbol, PERIOD_CURRENT, 0, rates_total, closePrices) <= 0)
      return false;

   // EMA calculation constants
   double k = 2.0 / (period + 1);

   // Initialize EMA with the first close price
   emaArray[0] = closePrices[0];

   // Calculate EMA for each bar
   for (int i = 1; i < rates_total; i++)
     {
      emaArray[i] = (closePrices[i] * k) + (emaArray[i - 1] * (1 - k));
     }
   return true;
}

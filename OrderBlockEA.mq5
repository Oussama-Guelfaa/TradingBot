//+------------------------------------------------------------------+
//|                                              OrderBlockEA.mq5    |
//|                                              |
//+------------------------------------------------------------------+
#property copyright ""
#property version   "3.04"
#property strict

#include "EMA_Calculations.mqh"
#include "Trend_Detection.mqh"
#include "OrderBlock_Detection.mqh"
#include "Order_Management.mqh"
#include "Utility_Functions.mqh"

// Input parameters
input double  LotSize          = 20;    // Fixed lot size
input double  StopLossPips     = 15;    // Stop Loss in pips
input double  TakeProfitPips   = 30;    // Take Profit in pips
input int     MaxTrades        = 10;    // Maximum number of simultaneous trades

input int     FastEMAPeriod    = 12;    // Fast EMA period for MACD
input int     SlowEMAPeriod    = 26;    // Slow EMA period for MACD

// Structure to hold order block information
struct OrderBlock
  {
   int direction;        // 1 for bullish, -1 for bearish
   double priceLevel;    // Price level of the order block
   datetime timestamp;   // Time when the order block was identified
  };

// Array to hold order blocks
OrderBlock orderBlocks[];

// EMA arrays
double FastEMA[];
double SlowEMA[];

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   // Set arrays as series (newest data at index 0)
   ArraySetAsSeries(FastEMA, true);
   ArraySetAsSeries(SlowEMA, true);

   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   // Nothing to clean up
  }

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   // Execute logic only on a new bar
   static datetime lastTime = 0;
   datetime currentTime = iTime(_Symbol, PERIOD_CURRENT, 0);
   if (currentTime == lastTime)
      return;
   lastTime = currentTime;

   // Calculate EMAs
   if (!CalculateEMA(FastEMAPeriod, FastEMA) || !CalculateEMA(SlowEMAPeriod, SlowEMA))
     {
      Print("EMA calculation failed");
      return;
     }

   // Determine trend using MACD method
   int trend = GetTrend(); // Returns 1 for bullish, -1 for bearish, 0 for no trend

   // Proceed only if trend is determined
   if (trend == 0)
     {
      // No clear trend, skip this bar
      return;
     }

   // Detect imbalance and order block based on trend
   DetectImbalanceAndOrderBlock(trend);

   // Check for price returning to order block levels
   for (int i = 0; i < ArraySize(orderBlocks); i++)
        {
         if (orderBlocks[i].direction == 1) // Bullish order block
           {
            // If price reaches the order block level
            double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
            if (bid <= orderBlocks[i].priceLevel)
              {
               // Check if we can open more trades
               if (CountOpenTradesBySymbol() < MaxTrades)
                 {
                  PlaceOrder(ORDER_TYPE_BUY);
                 }
               // Remove the order block from the array
               ArrayRemove(orderBlocks, i);
               i--; // Adjust the index after removal
              }
           }
         else if (orderBlocks[i].direction == -1) // Bearish order block
           {
            // If price reaches the order block level
            double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
            if (ask >= orderBlocks[i].priceLevel)
              {
               // Check if we can open more trades
               if (CountOpenTradesBySymbol() < MaxTrades)
                 {
                  PlaceOrder(ORDER_TYPE_SELL);
                 }
               // Remove the order block from the array
               ArrayRemove(orderBlocks, i);
               i--; // Adjust the index after removal
              }
           }

         else
           {
            // Remove order blocks that do not match current trend
            ArrayRemove(orderBlocks, i);
            i--; // Adjust the index after removal
           }
        }
  }

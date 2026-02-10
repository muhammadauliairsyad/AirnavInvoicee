import { NextResponse } from "next/server";
import { getUsdToIdrRate } from "@/lib/api/exchangeRate";

// GET /api/exchange-rate - Fetch current USD to IDR exchange rate
export async function GET() {
    try {
        const rate = await getUsdToIdrRate();

        return NextResponse.json({
            currency: "USD",
            targetCurrency: "IDR",
            rate,
            lastUpdated: new Date().toISOString(),
        });
    } catch (error) {
        console.error("Error fetching exchange rate:", error);
        return NextResponse.json(
            { error: "Failed to fetch exchange rate" },
            { status: 500 }
        );
    }
}

// Exchange rate API helper using ExchangeRate-API (free, no API key)
// Fetches real-time USD to IDR exchange rate

interface ExchangeRateResponse {
    result: string;
    rates: {
        IDR: number;
        [key: string]: number;
    };
    time_last_update_utc: string;
}

interface CachedRate {
    rate: number;
    timestamp: number;
}

// Cache duration: 1 hour
const CACHE_DURATION_MS = 60 * 60 * 1000;

// In-memory cache
let cachedRate: CachedRate | null = null;

/**
 * Fetch current USD to IDR exchange rate
 * Uses ExchangeRate-API (free, no API key required)
 * Results are cached for 1 hour
 */
export async function getUsdToIdrRate(): Promise<number> {
    // Check cache first
    if (cachedRate && Date.now() - cachedRate.timestamp < CACHE_DURATION_MS) {
        return cachedRate.rate;
    }

    try {
        const response = await fetch("https://open.er-api.com/v6/latest/USD", {
            next: { revalidate: 3600 }, // Next.js cache for 1 hour
        });

        if (!response.ok) {
            throw new Error(`API request failed: ${response.status}`);
        }

        const data: ExchangeRateResponse = await response.json();

        if (data.result !== "success" || !data.rates?.IDR) {
            throw new Error("Invalid API response");
        }

        const rate = Math.round(data.rates.IDR);

        // Update cache
        cachedRate = {
            rate,
            timestamp: Date.now(),
        };

        return rate;
    } catch (error) {
        console.error("Failed to fetch exchange rate:", error);

        // Return cached value if available, otherwise default
        if (cachedRate) {
            return cachedRate.rate;
        }

        // Fallback to reasonable default
        return 16000;
    }
}

/**
 * Convert IDR amount to USD
 */
export function idrToUsd(amountIdr: number, exchangeRate: number): number {
    if (exchangeRate <= 0) return 0;
    return amountIdr / exchangeRate;
}

/**
 * Convert USD amount to IDR
 */
export function usdToIdr(amountUsd: number, exchangeRate: number): number {
    return amountUsd * exchangeRate;
}

/**
 * Format currency amount
 */
export function formatCurrency(amount: number, currency: "IDR" | "USD"): string {
    if (currency === "USD") {
        return `$ ${amount.toLocaleString("en-US", { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`;
    }
    return `Rp ${amount.toLocaleString("id-ID")}`;
}

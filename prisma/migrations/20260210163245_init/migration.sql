-- CreateEnum
CREATE TYPE "Role" AS ENUM ('ADMIN', 'OPERATOR', 'VIEWER');

-- CreateEnum
CREATE TYPE "FlightType" AS ENUM ('DOM', 'INT');

-- CreateEnum
CREATE TYPE "PaymentStatus" AS ENUM ('UNPAID', 'PAID', 'UNDERPAID', 'OVERPAID');

-- CreateEnum
CREATE TYPE "MonitoringStatus" AS ENUM ('PENDING', 'BILLED', 'DEPOSIT', 'COMPLETED');

-- CreateEnum
CREATE TYPE "AdvanceExtend" AS ENUM ('ADVANCE', 'EXTEND');

-- CreateEnum
CREATE TYPE "Currency" AS ENUM ('IDR', 'USD');

-- CreateEnum
CREATE TYPE "SignatureType" AS ENUM ('PIC_DINAS', 'KEPALA_BANDARA');

-- CreateTable
CREATE TABLE "users" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "role" "Role" NOT NULL DEFAULT 'OPERATOR',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "flight_services" (
    "id" TEXT NOT NULL,
    "seqNo" SERIAL NOT NULL,
    "airline" TEXT NOT NULL,
    "flightType" "FlightType" NOT NULL,
    "flightNumber" TEXT NOT NULL,
    "flightNumber2" TEXT,
    "registration" TEXT NOT NULL,
    "aircraftType" TEXT NOT NULL,
    "depStation" TEXT NOT NULL,
    "arrStation" TEXT NOT NULL,
    "arrivalDate" TIMESTAMP(3) NOT NULL,
    "ataUtc" TIMESTAMP(3),
    "atdUtc" TIMESTAMP(3),
    "advanceExtend" "AdvanceExtend" NOT NULL,
    "serviceStartUtc" TIMESTAMP(3) NOT NULL,
    "serviceEndUtc" TIMESTAMP(3) NOT NULL,
    "useApp" BOOLEAN NOT NULL DEFAULT false,
    "useTwr" BOOLEAN NOT NULL DEFAULT false,
    "useAfis" BOOLEAN NOT NULL DEFAULT false,
    "currency" "Currency" NOT NULL DEFAULT 'IDR',
    "exchangeRate" INTEGER,
    "picDinas" TEXT,
    "durationMinutes" INTEGER NOT NULL,
    "billableHours" INTEGER NOT NULL,
    "grossApp" BIGINT NOT NULL DEFAULT 0,
    "grossTwr" BIGINT NOT NULL DEFAULT 0,
    "grossAfis" BIGINT NOT NULL DEFAULT 0,
    "grossTotal" BIGINT NOT NULL,
    "ppn" BIGINT NOT NULL,
    "netTotal" BIGINT NOT NULL,
    "receiptNo" TEXT NOT NULL,
    "receiptDate" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "status" "PaymentStatus" NOT NULL DEFAULT 'UNPAID',
    "paidAt" TIMESTAMP(3),
    "amountPaid" BIGINT,
    "paymentDifference" BIGINT,
    "paymentDays" INTEGER,
    "monitoringStatus" "MonitoringStatus" NOT NULL DEFAULT 'PENDING',
    "pph23Withheld" BOOLEAN NOT NULL DEFAULT false,
    "fakturPajakNo" TEXT,
    "fakturPajakDate" TIMESTAMP(3),
    "pdfReceiptPath" TEXT,
    "pdfBreakdownPath" TEXT,
    "pdfCombinedPath" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "flight_services_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "receipt_counters" (
    "id" TEXT NOT NULL,
    "year" INTEGER NOT NULL,
    "month" INTEGER NOT NULL,
    "code" TEXT NOT NULL,
    "lastSeq" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "receipt_counters_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "signatures" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "title" TEXT,
    "type" "SignatureType" NOT NULL,
    "imageData" TEXT NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "signatures_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "flight_services_seqNo_key" ON "flight_services"("seqNo");

-- CreateIndex
CREATE UNIQUE INDEX "flight_services_receiptNo_key" ON "flight_services"("receiptNo");

-- CreateIndex
CREATE INDEX "flight_services_flightType_idx" ON "flight_services"("flightType");

-- CreateIndex
CREATE INDEX "flight_services_status_idx" ON "flight_services"("status");

-- CreateIndex
CREATE INDEX "flight_services_arrivalDate_idx" ON "flight_services"("arrivalDate");

-- CreateIndex
CREATE INDEX "flight_services_receiptNo_idx" ON "flight_services"("receiptNo");

-- CreateIndex
CREATE INDEX "flight_services_monitoringStatus_idx" ON "flight_services"("monitoringStatus");

-- CreateIndex
CREATE UNIQUE INDEX "receipt_counters_year_month_code_key" ON "receipt_counters"("year", "month", "code");

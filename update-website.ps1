
# ============================================
# AUTO UPDATE WEBSITE PORTOFOLIO KE GITHUB
# Project: Webiste-idoed
# ============================================

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "   UPDATE WEBSITE PORTOFOLIO" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Pastikan terminal berada di folder script
Set-Location $PSScriptRoot

# Pastikan folder ini adalah Git repository
git rev-parse --is-inside-work-tree *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Folder ini bukan Git repository." -ForegroundColor Red
    Read-Host "Tekan Enter untuk keluar"
    exit 1
}

# Pastikan branch yang digunakan adalah main
$branch = git branch --show-current
if ($LASTEXITCODE -ne 0 -or $branch -ne "main") {
    Write-Host "ERROR: Branch aktif bukan main." -ForegroundColor Red
    Write-Host "Branch saat ini: $branch"
    Read-Host "Tekan Enter untuk keluar"
    exit 1
}

# Periksa perubahan lokal
$status = git status --short
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Gagal memeriksa status Git." -ForegroundColor Red
    Read-Host "Tekan Enter untuk keluar"
    exit 1
}

if (-not $status) {
    Write-Host "Tidak ada perubahan baru." -ForegroundColor Yellow
    Read-Host "Tekan Enter untuk keluar"
    exit 0
}

Write-Host "File yang berubah:" -ForegroundColor Yellow
git status --short
Write-Host ""
Write-Host "Periksa daftar di atas sebelum melanjutkan." -ForegroundColor Yellow
$confirm = Read-Host "Kirim perubahan ini ke GitHub? (Y/N)"

if ($confirm -notin @("Y", "y")) {
    Write-Host "Dibatalkan. Tidak ada perubahan yang diunggah." -ForegroundColor Yellow
    Read-Host "Tekan Enter untuk keluar"
    exit 0
}

# Masukkan perubahan ke staging
Write-Host ""
Write-Host "[1/3] Menyiapkan perubahan..." -ForegroundColor Cyan
git add .
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: git add gagal." -ForegroundColor Red
    Read-Host "Tekan Enter untuk keluar"
    exit 1
}

# Periksa apakah ada perubahan yang bisa di-commit
git diff --cached --quiet
if ($LASTEXITCODE -eq 0) {
    Write-Host "Tidak ada perubahan untuk di-commit." -ForegroundColor Yellow
    Read-Host "Tekan Enter untuk keluar"
    exit 0
}

# Simpan perubahan
Write-Host "[2/3] Membuat commit..." -ForegroundColor Cyan
$commitMessage = "Update portfolio $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
git commit -m $commitMessage
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Commit gagal. Periksa pesan Git di atas." -ForegroundColor Red
    Read-Host "Tekan Enter untuk keluar"
    exit 1
}

# Kirim ke GitHub
Write-Host "[3/3] Mengirim perubahan ke GitHub..." -ForegroundColor Cyan
git push origin main
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Push gagal. Periksa pesan Git di atas." -ForegroundColor Red
    Write-Host "Commit lokal sudah dibuat; jangan mengulang commit secara membabi buta." -ForegroundColor Yellow
    Read-Host "Tekan Enter untuk keluar"
    exit 1
}

Write-Host ""
Write-Host "BERHASIL! Website sudah dikirim ke GitHub." -ForegroundColor Green
Write-Host "Tunggu GitHub Pages memperbarui website." -ForegroundColor Green
Write-Host ""
Read-Host "Tekan Enter untuk menutup"

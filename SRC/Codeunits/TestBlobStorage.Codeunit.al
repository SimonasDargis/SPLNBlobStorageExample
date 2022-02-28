codeunit 50101 TestBlobStorage
{
    trigger OnRun()
    begin
        FileMgt.SaveFileDialog(FileName, FolderID);
        if FileName <> '' then begin
            BlobFile.Init();
            BlobFile."Parent ID" := FolderID;
            BlobFile.Name := FileName;
            BlobFile.BLOB.CreateOutStream(gOutStream);
            BlobFile.Type := BlobFile.Type::File;
            if REPORT.SaveAs(Report::"Customer - List", '', ReportFormat::Pdf, gOutStream) then begin
                BlobFile.Insert();
            end;
        end;
    end;

    var
        BlobFile: Record "BLOB File";
        gOutStream: OutStream;
        FolderID: Integer;
        FileName: Text[50];
        FileMgt: Codeunit BLOBFileManagement;
}






